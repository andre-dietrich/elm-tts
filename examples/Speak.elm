module Speak exposing (..)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events exposing (onClick, onInput)
import Tts


type Msg
    = Update String
    | Speak
    | ShutUp
    | ChangeVoice String
    | TTS (Result String Never)


type alias Model =
    { text : String
    , voice : Maybe String
    , msg : String
    , speaking : Bool
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
    ( { text = "Enter some text in here ..."
      , voice = Nothing
      , msg = "status: ok"
      , speaking = False
      }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    Html.div [ Attr.style [ ( "width", "400px" ) ] ]
        [ if model.speaking then
            Html.button
                [ Attr.style [ ( "width", "50%" ) ], onClick ShutUp ]
                [ Html.text "ShutUp!" ]
          else
            Html.button
                [ Attr.style [ ( "width", "50%" ) ], onClick Speak ]
                [ Html.text "Say It!" ]
        , Html.select
            [ Attr.style [ ( "width", "50%" ) ], onInput ChangeVoice ]
            (case Tts.voices True of
                Ok list ->
                    List.map
                        (\v ->
                            Html.option [ Attr.value v.name ] [ Html.text (v.name ++ " (" ++ v.lang ++ ")") ]
                        )
                        list

                Err msg ->
                    []
            )
        , Html.br [] []
        , Html.textarea
            [ Attr.style [ ( "width", "99%" ), ( "height", "100px" ) ]
            , Attr.value model.text
            , onInput Update
            ]
            []
        , Html.text model.msg
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Speak ->
            --( model, Task.perform SpeakErr (Tts.speakTask model.voice model.lang model.text) )
            case model.voice of
                Just name ->
                    ( { model
                        | msg = "status: started speaking"
                        , speaking = True
                      }
                    , Tts.speak_with_voice TTS name model.text
                    )

                Nothing ->
                    ( { model
                        | msg = "error: no voice slected"
                        , speaking = False
                      }
                    , Cmd.none
                    )

        ShutUp ->
            case Tts.shut_up of
                _ ->
                    ( { model | msg = "status: ok", speaking = False }, Cmd.none )

        Update text ->
            ( { model | text = text }, Cmd.none )

        TTS (Result.Ok _) ->
            ( { model | msg = "status: ok", speaking = False }, Cmd.none )

        TTS (Result.Err m) ->
            ( { model | msg = "error: " ++ m, speaking = False }, Cmd.none )

        ChangeVoice name ->
            ( { model | voice = Just name }, Cmd.none )
