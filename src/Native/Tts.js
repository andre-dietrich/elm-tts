var _andre_dietrich$elm_tts$Native_Tts = (function () {

    var VoiceList = [];

    window.onload = function() {
        try {
            VoiceList = speechSynthesis.getVoices();
            console.log("loaded");
            if (VoiceList.length == 0)
                speechSynthesis.onvoiceschanged = function(e) {
                    // Load the voices into the dropdown
                    VoiceList = speechSynthesis.getVoices();
                    // Don't add more options when voiceschanged again
                    speechSynthesis.onvoiceschanged = null;

                    console.log("voices loaded");
                };
        } catch (e) {
            console.log(e.message);
        }
    };

    function speak_with_voice(voice, text)
    {
        try {
            var tts = new SpeechSynthesisUtterance(text);

            for(var i=0; i<VoiceList.length; i++) {
                if (VoiceList[i].name == voice) {
                    tts.voice = VoiceList[i];
                    break;
                }
            }
            return _speak(tts);
        }
        catch (e) {
            callback(_elm_lang$core$Native_Scheduler.fail(e.message));
        }
    };

    function speak_with_lang(lang, text)
    {
        try {
            var tts = new SpeechSynthesisUtterance(text);

            for(var i=0; i<VoiceList.length; i++) {
                if (VoiceList[i].lang == lang) {
                    tts.voice = VoiceList[i];
                    break;
                }
            }

            return _speak(tts);
        }
        catch (e) {
            callback(_elm_lang$core$Native_Scheduler.fail(e.message));
        }
    };

    function _speak (tts) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback){
            try {
                speechSynthesis.cancel();

                tts.onend = function (event) {
                    console.log("Ende");
                    if (callback) {
                        callback(_elm_lang$core$Native_Scheduler.succeed());
                    }
                };

                tts.onerror = function (event) {
                    if (callback) {
                        callback(_elm_lang$core$Native_Scheduler.fail(e.message));
                    }
                };

                speechSynthesis.speak(tts);

            } catch (e) {
                callback(_elm_lang$core$Native_Scheduler.fail(e.message));
            }
        })
    };

    function shut_up () {

        try {
            if (speechSynthesis.speaking) {
                speechSynthesis.cancel();
            }
            return {
                ctor: "Ok",
                _0: null
            };
        } catch (e) {
            return {
                ctor: "Err",
                _0: e.message
            };
        }
    };

    function listen (continuous, interimResults, lang) {
        return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback){
            try {
                var recognition = new webkitSpeechRecognition();
                recognition.continuous = continuous;
                recognition.interimResults = interimResults;

                recognition.lang = lang;

                recognition.onend = function (event) {
                    if (callback) {
                        callback(_elm_lang$core$Native_Scheduler.fail("no results"));
                    }
                };

                recognition.onresult = function (event) {
                    // cancel onend handler
                    recognition.onend = null;
                    if (callback) {
                        callback(_elm_lang$core$Native_Scheduler.succeed(e.results[0][0].transcript));
                    }
                };

                // start listening
                recognition.start();
            } catch (e) {
                callback(_elm_lang$core$Native_Scheduler.fail(e.message));
            }
        });
    };

    function voices () {
        try {
            var nameList = [];

            for (var i=0; i<VoiceList.length; i++) {
                nameList.push ({ name: VoiceList[i].name,
                                 lang: VoiceList[i].lang });
            }

            return {
                ctor: "Ok",
                _0: nameList
            };
        } catch (e) {
            return {
                ctor: "Err",
                _0: e.message
            };
        }
    };



    function languages () {

        try {
            var langList = [];

            for (var i=0; i<VoiceList.length; i++) {
                langList.push (VoiceList[i].lang);
            }

            return {
                ctor: "Ok",
                _0: langList
            };

        } catch (e) {
            return {
                ctor: "Err",
                _0: e.message
            };
        }
    };


    return {
        speak_with_voice: F2(speak_with_voice),
        speak_with_lang: F2(speak_with_lang),
        listen: F3(listen),
        voices: voices,
        shut_up: shut_up,
        languages: languages
    };
})();
