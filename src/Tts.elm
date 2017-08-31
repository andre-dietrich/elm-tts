module Tts exposing (Voice, languages, listen, shut_up, speak_with_lang, speak_with_voice, voices)

{-| A native Html5 Text-To-Speech wrapper library.


# Basic access

@docs languages, listen, shut_up, speak_with_voice, speak_with_lang, voices, Voice

-}

import Json.Decode as Dec
import Native.Tts
import Result exposing (Result)
import Task exposing (Task)


{-| -}
type alias Recognition =
    { confidence : Float, transcript : String }


{-| -}
type alias Voice =
    { name : String, lang : String }


{-| -}
speak_with_voice : (Result err ok -> msg) -> String -> String -> Cmd msg
speak_with_voice resultToMessage voice_name text =
    Task.attempt resultToMessage (Native.Tts.speak_with_voice voice_name text)


{-| -}
speak_with_lang : (Result err ok -> msg) -> String -> String -> Cmd msg
speak_with_lang resultToMessage lang text =
    Task.attempt resultToMessage (Native.Tts.speak_with_lang lang text)


{-| -}
listen : (Result String String -> msg) -> Bool -> Bool -> String -> Cmd msg
listen resultToMessage continous interimResults lang =
    Task.attempt resultToMessage (Native.Tts.listen continous interimResults lang)


{-| -}
shut_up : () -> Result String String
shut_up _ =
    Native.Tts.shut_up ()


{-| -}
voices : Bool -> Result String (List Voice)
voices b =
    case Native.Tts.voices () of
        Ok list ->
            list
                |> Dec.decodeValue
                    (Dec.list
                        (Dec.map2 Voice
                            (Dec.field "name" Dec.string)
                            (Dec.field "lang" Dec.string)
                        )
                    )

        Err msg ->
            Err msg


{-| -}
languages : () -> Result String (List String)
languages _ =
    case Native.Tts.languages () of
        Ok list ->
            Dec.decodeValue (Dec.list Dec.string) list

        Err msg ->
            Err msg
