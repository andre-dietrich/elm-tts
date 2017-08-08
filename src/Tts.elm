module Tts exposing (..)

import Json.Decode as Dec
import Json.Encode as Enc
import Native.Tts


--type alias Voice =
--    { name : String
--    , lang : String
--    , voiceURI : String
--    , localService : Bool
--    , default : Bool
--    }


speak : Maybe String -> String -> String -> Bool
speak voice lang text =
    let
        v =
            case voice of
                Just str ->
                    Enc.string str

                Nothing ->
                    Enc.null

        res =
            Native.Tts.speak v lang text
    in
    case res of
        Ok _ ->
            True

        Err _ ->
            False


voices : Result String (List String)
voices =
    decode_string_list (Native.Tts.languages ())


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
