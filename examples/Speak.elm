module Speak exposing (..)

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events exposing (onClick, onInput)
import Tts


type Msg
    = Update String
    | Speak
    | ChangeVoice String


type alias Model =
    { text : String
    , lang : String
    , voice : Maybe String
    , error : Maybe String
    , voices : List String
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
    ( voice_list
        { text = "Enter some text in here ..."
        , lang = "en_US"
        , voice = Nothing
        , error = Nothing
        , voices = []
        }
    , Cmd.none
    )


voice_list : Model -> Model
voice_list model =
    case Tts.voices of
        Ok list ->
            { model | voices = list }

        Err msg ->
            { model | voices = [], error = Just msg }


view : Model -> Html Msg
view model =
    Html.div [ Attr.style [ ( "width", "400px" ) ] ]
        [ Html.button
            [ Attr.style [ ( "width", "50%" ) ]
            , onClick Speak
            ]
            [ Html.text "Say It!" ]
        , Html.select
            [ Attr.style [ ( "width", "50%" ) ]
            , onInput ChangeVoice
            ]
            (List.map
                (\v -> Html.option [ Attr.value v ] [ Html.text v ])
                model.voices
            )
        , Html.br [] []
        , Html.textarea
            [ Attr.style
                [ ( "width", "99%" )
                , ( "height", "100px" )
                ]
            , Attr.value model.text
            , onInput Update
            ]
            []
        , Html.text
            (case model.error of
                Just err ->
                    "error: " ++ err

                Nothing ->
                    "status: ok"
            )
        ]


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Speak ->
            ( speak model, Cmd.none )

        Update text ->
            ( { model | text = text }, Cmd.none )

        ChangeVoice name ->
            ( { model | voice = Just name }, Cmd.none )


speak : Model -> Model
speak model =
    case Tts.speak model.voice model.lang model.text of
        Ok _ ->
            { model | error = Nothing }

        Err msg ->
            { model | error = Just msg }
