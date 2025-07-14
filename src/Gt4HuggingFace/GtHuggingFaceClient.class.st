Class {
    #name : #GtHuggingFaceClient,
    #superclass : #Object,
    #instVars : [ 'baseUrl', 'apiKey', 'history' ],
    #classVars : [ 'ApiKeyFile' ],
    #category : #Gt4HuggingFace
}

{ #category : #accessing }
GtHuggingFaceClient class >> apiKeyFile [
    ^ ApiKeyFile
]

{ #category : #accessing }
GtHuggingFaceClient class >> apiKeyFile: aFile [
    ApiKeyFile := aFile
]

{ #category : #accessing }
GtHuggingFaceClient class >> apiKeyFileContents [
    ^ ApiKeyFile contents trimBoth
]

{ #category : #accessing }
GtHuggingFaceClient class >> defaultApiKeyFile [
    ^ FileLocator home / '.secrets' / 'hugging-face-api-key.txt'
]

{ #category : #initialization }
GtHuggingFaceClient class >> initialize [
    ApiKeyFile := self defaultApiKeyFile
]

{ #category : #accessing }
GtHuggingFaceClient class >> withApiKeyFromFile [
    ^ self new apiKey: self apiKeyFileContents
]

{ #category : #accessing }
GtHuggingFaceClient >> apiKey [
    ^ apiKey
]

{ #category : #accessing }
GtHuggingFaceClient >> apiKey: aKey [
    apiKey := aKey
]

{ #category : #accessing }
GtHuggingFaceClient >> baseUrl [
    ^ baseUrl
]

{ #category : #accessing }
GtHuggingFaceClient >> baseUrl: aUrl [
    baseUrl := aUrl asZnUrl
]

{ #category : #accessing }
GtHuggingFaceClient >> defaultBaseUrl [
    ^ 'https://api-inference.huggingface.co' asZnUrl
]

{ #category : #initialization }
GtHuggingFaceClient >> initialize [
    super initialize.
    history := GtLlmRequestHistory new.
    self baseUrl: self defaultBaseUrl
]

{ #category : #private }
GtHuggingFaceClient >> initializeClient [
    | client |
    client := ZnClient new.
    client forJsonREST.
    client timeout: 600.
    apiKey ifNotNil: [ client headerAt: 'Authorization' put: 'Bearer ' , apiKey ].
    ^ client
]

{ #category : #http }
GtHuggingFaceClient >> post: aPath withEntity: anEntity [
    | c response |
    c := self initializeClient.
    c url: self baseUrl / aPath.
    c contents: anEntity.
    response := c post.
    history add: c request -> c response.
    ^ response
]

{ #category : #api }
GtHuggingFaceClient >> generateResponseWithModel: aModel andInputs: aString [
    ^ GtHuggingFaceGenerateResponseAPIClient new
        client: self;
        model: aModel;
        inputs: aString;
        perform
]

{ #category : #accessing }
GtHuggingFaceClient >> history [
    ^ history
]
