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
    ( Model "Enter some text in here ..." "en_US" Nothing, Cmd.none )


voices : List String
voices =
    case Tts.voices of
        Ok list ->
            list

        Err _ ->
            []


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.button [ onClick Speak ]
            [ Html.text "Say It!" ]
        , Html.select [ onInput ChangeVoice ]
            (List.map
                (\v -> Html.option [ Attr.value v ] [ Html.text v ])
                voices
            )
        , Html.br [] []
        , Html.textarea
            [ onInput Update
            , Attr.value model.text
            ]
            []
        ]


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Speak ->
            let
                x =
                    Tts.speak model.voice model.lang model.text
            in
            ( model, Cmd.none )

        Update text ->
            ( { model | text = text }, Cmd.none )

        ChangeVoice name ->
            ( { model | voice = Just name }, Cmd.none )
