module Tts exposing (languages, speak, voices)

{-| A native Html5 Text-To-Speech wrapper library.


# Basic access

@docs speak, voices, languages

-}

import Json.Decode as Dec
import Json.Encode as Enc
import Native.Tts
import Result exposing (Result)
import Task exposing (Task)


{-| -}
speak : (Result err ok -> msg) -> Maybe String -> String -> String -> Cmd msg
speak resultToMessage voice lang text =
    let
        v =
            case voice of
                Just str ->
                    Enc.string str

                Nothing ->
                    Enc.null
    in
    Task.attempt resultToMessage (Native.Tts.speak v lang text)


{-| -}
voices : Result String (List String)
voices =
    decode_string_list (Native.Tts.voices ())


{-| -}
languages : Result String (List String)
languages =
    decode_string_list (Native.Tts.languages ())


decode_string_list : Result String Enc.Value -> Result String (List String)
decode_string_list result =
    case result of
        Ok list ->
            Dec.decodeValue (Dec.list Dec.string) list

        Err msg ->
            Err msg
