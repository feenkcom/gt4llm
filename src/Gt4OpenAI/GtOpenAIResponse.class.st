Class {
	#name : #GtOpenAIResponse,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'createdAt',
		'status',
		'error',
		'incompleteDetails',
		'instructions',
		'maxOutputTokens',
		'model',
		'output',
		'parallelToolCalls',
		'previousResponseId',
		'reasoning',
		'store',
		'temperature',
		'text',
		'toolChoice',
		'tools',
		'topP',
		'truncation',
		'usage',
		'user',
		'metadata'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIResponse class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#status -> #status.
		#error -> #error.
		#incomplete_details -> #incompleteDetails.
		#instructions -> #instructions.
		#max_output_tokens -> #maxOutputTokens.
		#model -> #model.
		#output -> #output.
		#parallel_tool_calls -> #parallelToolCalls.
		#previous_response_id -> #previousResponseId.
		#reasoning -> #reasoning.
		#store -> #store.
		#temperature -> #temperature.
		#text -> #text.
		#tool_choice -> #toolChoice.
		#tools -> #tools.
		#top_p -> #topP.
		#truncation -> #truncation.
		#usage -> #usage.
		#user -> #user.
		#metadata -> #metadata}
]

{ #category : #accessing }
GtOpenAIResponse >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIResponse >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> error [
	^ error
]

{ #category : #accessing }
GtOpenAIResponse >> error: anObject [
	error := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIResponse >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> incompleteDetails [
	^ incompleteDetails
]

{ #category : #accessing }
GtOpenAIResponse >> incompleteDetails: anObject [
	incompleteDetails := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> instructions [
	^ instructions
]

{ #category : #accessing }
GtOpenAIResponse >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> maxOutputTokens [
	^ maxOutputTokens
]

{ #category : #accessing }
GtOpenAIResponse >> maxOutputTokens: anObject [
	maxOutputTokens := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> metadata [
	^ metadata
]

{ #category : #accessing }
GtOpenAIResponse >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIResponse >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> output [
	^ output
]

{ #category : #accessing }
GtOpenAIResponse >> output: anObject [
	output := anObject collect: [ :aMessage | GtOpenAIMessage from: aMessage ]
]

{ #category : #accessing }
GtOpenAIResponse >> parallelToolCalls [
	^ parallelToolCalls
]

{ #category : #accessing }
GtOpenAIResponse >> parallelToolCalls: anObject [
	parallelToolCalls := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> previousResponseId [
	^ previousResponseId
]

{ #category : #accessing }
GtOpenAIResponse >> previousResponseId: anObject [
	previousResponseId := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> reasoning [
	^ reasoning
]

{ #category : #accessing }
GtOpenAIResponse >> reasoning: anObject [
	reasoning := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> status [
	^ status
]

{ #category : #accessing }
GtOpenAIResponse >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> store [
	^ store
]

{ #category : #accessing }
GtOpenAIResponse >> store: anObject [
	store := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> temperature [
	^ temperature
]

{ #category : #accessing }
GtOpenAIResponse >> temperature: anObject [
	temperature := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> text [
	^ text
]

{ #category : #accessing }
GtOpenAIResponse >> text: anObject [
	text := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> toolChoice [
	^ toolChoice
]

{ #category : #accessing }
GtOpenAIResponse >> toolChoice: anObject [
	toolChoice := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIResponse >> tools: anObject [
	tools := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> topP [
	^ topP
]

{ #category : #accessing }
GtOpenAIResponse >> topP: anObject [
	topP := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> truncation [
	^ truncation
]

{ #category : #accessing }
GtOpenAIResponse >> truncation: anObject [
	truncation := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> usage [
	^ usage
]

{ #category : #accessing }
GtOpenAIResponse >> usage: anObject [
	usage := anObject
]

{ #category : #accessing }
GtOpenAIResponse >> user [
	^ user
]

{ #category : #accessing }
GtOpenAIResponse >> user: anObject [
	user := anObject
]
