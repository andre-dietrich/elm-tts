var _andre_dietrich$elm_tts$Native_Tts = (function () {
    var speak = function(voice, lang, text) {
        try {
            let tts = new SpeechSynthesisUtterance(text);
            tts.lang = lang;
            for(var i=0; i<speechSynthesis.getVoices().length; i++) {
              if (speechSynthesis.getVoices()[i].name == voice) {
                tts.voice = speechSynthesis.getVoices()[i];
                break;
              }
            }
            speechSynthesis.speak(tts);
            return {
                ctor: "Ok",
                _0: ""
            };
        } catch (e) {
            return {
                ctor: "Err",
                _0: e.message
            };
        }
    };

    var voices = function() {
        try {
            let name_list = [];
            let voice_list = speechSynthesis.getVoices();

            for (var i=0; i<voice_list.length; i++) {
                name_list.push (voice_list[i].name);
            }

            return {
                ctor: "Ok",
                _0: name_list.sort()
            };
        } catch (e) {
            return {
                ctor: "Err",
                _0: e.message
            };
        }
    };

    var languages = function() {
        try {
            let lang_list = [];
            let voice_list = speechSynthesis.getVoices();

            for (var i=0; i<voice_list.length; i++) {
                lang_list.push (voice_list[i].lang);
            }

            return {
                ctor: "Ok",
                _0: lang_list.sort()
            };
        } catch (e) {
            return {
                ctor: "Err",
                _0: e.message
            };
        }
    };


    return {
        speak: F3(speak),
        voices: voices,
        languages: languages
    };
})();
