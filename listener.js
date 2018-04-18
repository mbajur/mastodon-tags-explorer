const WebSocket = require('ws');
const h2p = require('html2plaintext');
const redis = require('redis');
const Sidekiq = require('sidekiq');

redisClient = redis.createClient();
sidekiq = new Sidekiq(redisClient);

function getHashTags(inputText) {
  var regex = /(?:^|\s)(?:#)([a-zA-Z\d]+)/gm;
  var matches = [];
  var match;

  while ((match = regex.exec(inputText))) {
    matches.push(match[1]);
  }

  return matches;
}

const instances = [
  { host: 'mastodon.social' },
  { host: 'photog.social' },
  { host: 'vis.social' }
]

instances.forEach((instance) => {
  const ws = new WebSocket(`wss://${instance.host}/api/v1/streaming/?stream=public`);

  ws.on('open', function open() {
    console.log(`Listening at ${instance.host}`)
  });

  ws.on('message', function incoming(d) {
    let data = JSON.parse(d)

    if (data.event == 'update') {
      let payload = JSON.parse(data.payload)
      let language = payload.language
      let tootHost = payload.account.acct.split('@')[1]
      let host = tootHost || instance.host
      let id = payload.id

      // Parse content
      let content = payload.content
      content = content.replace('\'','')
      content = h2p(content)

      // Parse tags
      let tags = getHashTags(content)

      if (tags == null || tags.length == 0) {
        return false
      }

      let job = sidekiq.enqueue('CreateTootWorker',
        [host, id, language, tags],
        { queue: 'default' }
      )

      console.log({
        instance: host,
        id: id,
        language: language,
        tags: tags
      })
      console.log('----------------------------------')
    }
  })
})
