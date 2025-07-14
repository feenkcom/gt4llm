Class {
    #name : #GtHuggingFaceProvider,
    #superclass : #GtLlmProvider,
    #instVars : [ 'client', 'model', 'assistantWorking' ],
    #category : #Gt4HuggingFace
}

{ #category : #'class initialization' }
GtHuggingFaceProvider class >> default [
    ^ [ self withApiKeyFromFile ]
]

{ #category : #'class initialization' }
GtHuggingFaceProvider class >> providerName [
    ^ 'HuggingFace'
]

{ #category : #'class initialization' }
GtHuggingFaceProvider class >> withApiKeyFromFile [
    ^ self new apiKey: GtHuggingFaceClient apiKeyFileContents
]

{ #category : #accessing }
GtHuggingFaceProvider >> apiKey: aString [
    client apiKey: aString
]

{ #category : #accessing }
GtHuggingFaceProvider >> client [
    ^ client
]

{ #category : #accessing }
GtHuggingFaceProvider >> initialize [
    super initialize.
    model := 'bigcode/starcoder'.
    assistantWorking := false.
    self initializeClient
]

{ #category : #private }
GtHuggingFaceProvider >> initializeClient [
    client := GtHuggingFaceClient new
]

{ #category : #'provider' }
GtHuggingFaceProvider >> sendAssistantMessage: aMessage [
    self chat addMessage: aMessage.
    self triggerAssistant
]

{ #category : #'provider' }
GtHuggingFaceProvider >> status [
    ^ assistantWorking
        ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
        ifFalse: [ GtLlmAssistantChatReadyStatus new ]
]

{ #category : #'provider' }
GtHuggingFaceProvider >> triggerAssistant [
    | result |
    self chat signalRunHasStarted.
    assistantWorking := true.
    result := client
        generateResponseWithModel: model
        andInputs: self chat messages collect: [:m | m contentText ] joinSeparatedBy: '\n'.
    self chat addMessage: (self assistantMessageClass new
        content: (result at: 'generated_text' ifAbsent: ['']);
        role: 'assistant').
    assistantWorking := false.
    self chat signalRunIsDone
]
