module Main exposing (main)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Browser.Dom as Dom
import Browser.Navigation as Navigation
import Hotkeys exposing (onEnter)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Markdown
import String.Extra as StringUtils
import Svg
import Svg.Attributes
import Task



-- MAIN


main : Program () Model Msg
main =
    Browser.element { init = init, subscriptions = subscriptions, update = update, view = view }



-- MODEL


type alias Model =
    { title : String
    , description : String
    , previewDescription : Bool
    , currentFragmentToAdd : FragmentType
    , fragments : List Fragment
    , tags : List String
    , newTag : String
    , validationErrors : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { title = ""
      , description = ""
      , previewDescription = False
      , currentFragmentToAdd = LinkFragment
      , fragments = []
      , tags = []
      , newTag = ""
      , validationErrors = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | Update Field String
    | ToggleDescriptionPreview
    | AddFragment FragmentType
    | AddTag
    | RemoveTag String
    | UpdateFragment Int Fragment
    | Submit
    | ServerResponse (Result (RequestError String) String)


type Field
    = Title
    | Description
    | NewTag


type Fragment
    = Link { title : String, url : String }


type FragmentType
    = LinkFragment


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Update field val ->
            case field of
                Title ->
                    ( { model | title = val }, Cmd.none )

                Description ->
                    ( { model | description = val }, Cmd.none )

                NewTag ->
                    ( { model | newTag = val }, Cmd.none )

        AddTag ->
            if (String.isEmpty <| String.trim model.newTag) || List.member model.newTag model.tags then
                ( model, Cmd.none )

            else
                ( { model | tags = model.tags ++ [String.trim model.newTag], newTag = "" }, Task.attempt (\_ -> NoOp) (Dom.focus "tags-input") )

        RemoveTag tag ->
            ( { model | tags = List.filter (\t -> t /= tag) model.tags }, Cmd.none )

        ToggleDescriptionPreview ->
            ( { model | previewDescription = not model.previewDescription }, Cmd.none )

        AddFragment _ ->
            ( { model | fragments = model.fragments ++ [ Link { title = "", url = "" } ] }, Cmd.none )

        UpdateFragment fragmentIndex updatedFragment ->
            ( { model
                | fragments =
                    List.indexedMap
                        (\index f ->
                            if index == fragmentIndex then
                                updatedFragment

                            else
                                f
                        )
                        model.fragments
              }
            , Cmd.none
            )

        Submit ->
            ( model, submitForm model )

        ServerResponse (Ok memoryUrl) ->
            ( model, Navigation.load memoryUrl )

        ServerResponse (Err err) ->
            case err of
                ServerError 422 response ->
                    let
                        errors =
                            Debug.log "entity errors" <| parseValidationErrors response
                    in
                    ( model, Cmd.none )

                _ ->
                    let
                        e =
                            Debug.log "error" err
                    in
                    ( model, Cmd.none )


submitForm : Model -> Cmd Msg
submitForm model =
    Http.post { url = "/api/v1/memories", body = Http.jsonBody <| encodeMemory model, expect = expectJson memoryDecoder ServerResponse }

encodeMemory : Model -> Encode.Value
encodeMemory model =
    Encode.object
        [ ( "memory"
          , Encode.object
                [ ( "title", Encode.string model.title )
                , ( "description", Encode.string model.description )
                , ( "tags", Encode.list Encode.string model.tags )
                , ( "fragments", Encode.list encodeFragment model.fragments )
                ]
          )
        ]


encodeFragment : Fragment -> Encode.Value
encodeFragment (Link { title, url }) =
    Encode.object
        [ ( "type", Encode.string "link" )
        , ( "attributes"
          , Encode.object
                [ ( "title", Encode.string title )
                , ( "url", Encode.string url )
                ]
          )
        ]


memoryDecoder : Decode.Decoder String
memoryDecoder =
    Decode.field "memory_url" Decode.string



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        toggleDescriptionText =
            if model.previewDescription then
                "Edit"

            else
                "Preview"
    in
    div []
        [ div [] [ input [ placeholder "Title", onInput (Update Title), value model.title, class "input" ] [] ]
        , renderDescription model
        , button [ onClick ToggleDescriptionPreview ] [ text toggleDescriptionText ]
        , div [ class "fragemnts-section" ] <| List.indexedMap renderFragmentForm model.fragments
        , div [ class "row row-horizontal row-end" ] [ renderFragmentAdder model ]
        , renderTagsSection model
        , button [ onClick Submit, class "button button--full-width" ] [ text "Submit" ]
        ]


renderDescription : Model -> Html Msg
renderDescription model =
    if model.previewDescription then
        Markdown.toHtml [ class "content", style "width" "100%" ] model.description

    else
        textarea [ value model.description, onInput (Update Description), placeholder "Description", class "textarea" ] []


renderFragmentAdder : Model -> Html Msg
renderFragmentAdder model =
    div [ class "fragment-select" ] [ renderFragmentList model, button [ onClick (AddFragment model.currentFragmentToAdd) ] [ text "Add" ] ]


renderFragmentList : Model -> Html Msg
renderFragmentList model =
    select []
        [ option [ selected (model.currentFragmentToAdd == LinkFragment) ] [ text "Link" ]
        ]


renderFragmentForm : Int -> Fragment -> Html Msg
renderFragmentForm fragmentIndex (Link ({ title, url } as attrs)) =
    let
        updateTitle =
            \newTitle -> UpdateFragment fragmentIndex (Link { attrs | title = newTitle })

        updateUrl =
            \newUrl -> UpdateFragment fragmentIndex (Link { attrs | url = newUrl })
    in
    fieldset [ class "fieldset" ]
        [ legend [] [ text "Link" ]
        , input [ value title, placeholder "Title", onInput updateTitle, class "input" ] []
        , input [ value url, placeholder "Url", onInput updateUrl, class "input" ] []
        ]


renderTagsSection : Model -> Html Msg
renderTagsSection model =
    div [ class "row row-wrap tags-section" ] <|
        List.map renderTag model.tags
            ++ [ input [ onInput (Update NewTag), onEnter AddTag, id "tags-input", placeholder "New Tag" ] [] ]


renderTag : String -> Html Msg
renderTag tag =
    span [ class "tag" ] [ span [ class "tag-label" ] [ text tag ], span [ onClick (RemoveTag tag), class "tag-remove" ] [ renderRemoveIcon ] ]


renderRemoveIcon : Html Msg
renderRemoveIcon =
    Svg.svg
        [ Svg.Attributes.viewBox "0 0 24 24", Svg.Attributes.width "24", Svg.Attributes.height "24" ]
        [ Svg.path [ Svg.Attributes.d "M12 2C6.47 2 2 6.47 2 12s4.47 10 10 10 10-4.47 10-10S17.53 2 12 2zm5 13.59L15.59 17 12 13.41 8.41 17 7 15.59 10.59 12 7 8.41 8.41 7 12 10.59 15.59 7 17 8.41 13.41 12 17 15.59z" ] [] ]


type RequestError errType
    = ServerError Int errType
    | ClientError Http.Error



-- utils


expectJson : Decode.Decoder value -> (Result (RequestError String) value -> Msg) -> Http.Expect Msg
expectJson onSuccessDecoder toMsg =
    Http.expectStringResponse toMsg (httpResponseParser onSuccessDecoder)


httpResponseParser : Decode.Decoder value -> (Http.Response String -> Result (RequestError String) value)
httpResponseParser decoder =
    \response ->
        case response of
            Http.BadUrl_ url ->
                Err <| ClientError (Http.BadUrl url)

            Http.Timeout_ ->
                Err (ClientError Http.Timeout)

            Http.NetworkError_ ->
                Err (ClientError Http.NetworkError)

            Http.BadStatus_ metadata body ->
                Err (ServerError metadata.statusCode body)

            Http.GoodStatus_ _ body ->
                case Decode.decodeString decoder body of
                    Ok value ->
                        Ok value

                    Err err ->
                        Err <| ClientError (Http.BadBody (Decode.errorToString err))


parseValidationErrors : String -> List String
parseValidationErrors response =
    let
        errorsDecoder =
            Decode.keyValuePairs (Decode.list Decode.string)

        errorsAccumulator field =
            List.foldl (\error acc -> acc ++ [ StringUtils.toSentenceCase (field ++ " " ++ error) ])
    in
    case Decode.decodeString (Decode.field "errors" errorsDecoder) response of
        Ok val ->
            List.concatMap (\( field, errors ) -> errorsAccumulator field [] errors) val

        Err _ ->
            [ "Error parsing validation errors" ]
