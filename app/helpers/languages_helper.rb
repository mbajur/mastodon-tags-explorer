module LanguagesHelper
  def language_info_from_code(code)
    LanguageList::LanguageInfo.find(code)
  end
end
