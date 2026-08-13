Class {
	#name : #GtLOpenAiResponsesProvider,
	#superclass : #GtLModelProvider,
	#category : #'Gt4LlmModel-Provider'
}

{ #category : #accessing }
GtLOpenAiResponsesProvider class >> providerName [
	^ 'OpenAI'
]

{ #category : #accessing }
GtLOpenAiResponsesProvider class >> withDefaultSetup [

	^ self new loadApiKeyFromFile
]

{ #category : #testing }
GtLOpenAiResponsesProvider >> assistantMessageHasCompactionResponse: anAssistantMessage [
	"Answer a boolean indicating whether the provided message contains a compaction response.
	E.g. OpenAI will include an encrypted_content output for server-side compaction.
	To be removed."
	| response |
	
	response := anAssistantMessage requestResponse result.
	^ response output anySatisfy: [ :jsonObject |
		(jsonObject at: 'type' ifAbsent: []) = 'compaction' ].
]

{ #category : #'as yet unclassified' }
GtLOpenAiResponsesProvider >> automaticCompactionMessagesFrom: aResult inputMessage: anInputMessage [
	"Answer one message per automatic compaction output, preserving response order.
	Explicit compaction requests are classified through the normal response path."

	| outputItems |

	anInputMessage isCompactionRequest ifTrue: [ ^ #() ].

	outputItems := aResult rawData
		at: 'output'
		ifAbsent: [ #() ].

	^ (outputItems select: [ :each |
		(each at: 'type' ifAbsent: [ nil ]) = 'compaction' ])
		collect: [ :each |
			GtLModelCompactionMessage new
				initializeFromCompactionOutput: each
				result: aResult
				provider: self;
				yourself ]
]

{ #category : #initialization }
GtLOpenAiResponsesProvider >> initialize [

	super initialize.
	model
		provider: self;
		client: GtLModelOpenAiClient new loadApiKeyFromFile.
	self responses.
]
