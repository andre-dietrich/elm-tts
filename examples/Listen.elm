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
    , lang : Maybe String
    , lang_list : List String
    , msg : String
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
    ( lang_list <|
        lang_list
            { result = ""
            , lang = Nothing
            , lang_list = []
            , msg = ""
            }
    , Cmd.none
    )


lang_list : Model -> Model
lang_list model =
    case Tts.languages () of
        --Ok [] ->
        --    lang_list model
        Ok list ->
            { model
                | lang_list = list
                , lang = List.head list
            }

        Err msg ->
            { model | msg = "error: " ++ msg }


view : Model -> Html Msg
view model =
    Html.div [ Attr.style [ ( "width", "400px" ) ] ]
        [ Html.button
            [ Attr.style [ ( "width", "50%" ) ]
            , onClick Listen
            ]
            [ Html.text "Start Listening" ]
        , Html.select
            [ Attr.style [ ( "width", "50%" ) ] ]
            (case Tts.languages () of
                Ok list ->
                    List.map
                        (\l ->
                            Html.option [ Attr.value l ] [ Html.text l ]
                        )
                        list

                Err msg ->
                    []
            )
        , Html.br [] []
        , Html.text model.msg
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
