module Listen exposing (..)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Tts


type Msg
    = Listen
    | TTS (Result String String)


type alias Model =
    { result : String
    , lang : String
    }


main : Program Never Model Msg
main =
    Html.program
        { update = update
        , init = init
        , subscriptions = \_ -> Sub.none
        , view = view
        }


init : ( Model, Cmd msg )
init =
    ( { result = ""
      , lang = "en_US"
      }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    Html.div [ Attr.style [ ( "width", "400px" ) ] ]
        [ Html.button
            [ Attr.style [ ( "width", "50%" ) ]
            , onClick Listen
            ]
            [ Html.text "Say It!" ]
        , Html.br [] []
        , Html.text model.result
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Listen ->
            --( model, Task.perform SpeakErr (Tts.speakTask model.voice model.lang model.text) )
            ( model, Tts.listen TTS False False "de_DE" )

        TTS (Result.Ok m) ->
            ( { model | result = m }, Cmd.none )

        TTS (Result.Err m) ->
            ( { model | result = m }, Cmd.none )
