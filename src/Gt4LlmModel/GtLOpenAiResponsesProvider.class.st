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

{ #category : #private }
GtLOpenAiResponsesProvider >> automaticCompactionMessagesFrom: aResult inputMessage: anInputMessage [
	"Answer one message per automatic compaction output, preserving response order.
	Explicit compaction requests are classified through the normal response path.
	During history reconstruction tool continuation requests have no reconstructed
	input message, and are still eligible to contain automatic compaction output."

	| outputItems |

	(anInputMessage notNil and: [ anInputMessage isCompactionRequest ])
		ifTrue: [ ^ #() ].

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

{ #category : #private }
GtLOpenAiResponsesProvider >> partitionAutomaticCompactionMessages: compactionMessages from: aResult inputMessage: anInputMessage [
	"Preserve the order of OpenAI output items by splitting compaction output
	around the assistant message output."

	| outputItems assistantOutputIndex preExecutionMessages postExecutionMessages |
	outputItems := aResult rawData
		at: 'output'
		ifAbsent: [ #() ].
	assistantOutputIndex := outputItems
		findFirst: [ :each | (each at: 'type' ifAbsent: [ nil ]) = 'message' ].
	assistantOutputIndex = 0 ifTrue: [ ^ { compactionMessages. #() } ].

	preExecutionMessages := compactionMessages select: [ :each |
		(outputItems identityIndexOf: each rawData ifAbsent: [ 0 ]) < assistantOutputIndex ].
	postExecutionMessages := compactionMessages select: [ :each |
		(outputItems identityIndexOf: each rawData ifAbsent: [ 0 ]) > assistantOutputIndex ].
	^ { preExecutionMessages. postExecutionMessages }
]
