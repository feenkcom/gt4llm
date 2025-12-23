Class {
	#name : #GtLOpenAIResponse,
	#superclass : #GtLEntity,
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
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIResponse class >> leJsonV4Name [

	^ #gtOpenAIResponse
]

{ #category : #'as yet unclassified' }
GtLOpenAIResponse class >> serializationProperties [
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
GtLOpenAIResponse >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIResponse >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> error [
	^ error
]

{ #category : #accessing }
GtLOpenAIResponse >> error: anObject [
	error := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIResponse >> hasToolCalls [
	^ self toolCalls isNotEmpty
]

{ #category : #accessing }
GtLOpenAIResponse >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIResponse >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> incompleteDetails [
	^ incompleteDetails
]

{ #category : #accessing }
GtLOpenAIResponse >> incompleteDetails: anObject [
	incompleteDetails := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLOpenAIResponse >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> maxOutputTokens [
	^ maxOutputTokens
]

{ #category : #accessing }
GtLOpenAIResponse >> maxOutputTokens: anObject [
	maxOutputTokens := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> metadata [
	^ metadata
]

{ #category : #accessing }
GtLOpenAIResponse >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIResponse >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> output [
	^ output
]

{ #category : #accessing }
GtLOpenAIResponse >> output: anObject [
	output := anObject collect: [ :aMessage | GtOpenAIMessage from: aMessage ] as: Array
]

{ #category : #accessing }
GtLOpenAIResponse >> parallelToolCalls [
	^ parallelToolCalls
]

{ #category : #accessing }
GtLOpenAIResponse >> parallelToolCalls: anObject [
	parallelToolCalls := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> previousResponseId [
	^ previousResponseId
]

{ #category : #accessing }
GtLOpenAIResponse >> previousResponseId: anObject [
	previousResponseId := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> reasoning [
	^ reasoning
]

{ #category : #accessing }
GtLOpenAIResponse >> reasoning: anObject [
	reasoning := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> status [
	^ status
]

{ #category : #accessing }
GtLOpenAIResponse >> status: anObject [
	status := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> store [
	^ store
]

{ #category : #accessing }
GtLOpenAIResponse >> store: anObject [
	store := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> temperature [
	^ temperature
]

{ #category : #accessing }
GtLOpenAIResponse >> temperature: anObject [
	temperature := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> text [
	^ text
]

{ #category : #accessing }
GtLOpenAIResponse >> text: anObject [
	text := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIResponse >> toolCalls [
	^ self output
		select: [ :aMessage | (aMessage rawData at: 'type') = 'function_call' ]
		thenCollect: [ :aMessage | 
			GtLFunctionToolCall new
				rawData: aMessage rawData;
				id: (aMessage rawData at: 'call_id');
				name: (aMessage rawData at: 'name');
				arguments: (STONJSON fromString: (aMessage rawData at: 'arguments')) ]
]

{ #category : #accessing }
GtLOpenAIResponse >> toolChoice [
	^ toolChoice
]

{ #category : #accessing }
GtLOpenAIResponse >> toolChoice: anObject [
	toolChoice := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> tools [
	^ tools
]

{ #category : #accessing }
GtLOpenAIResponse >> tools: anObject [
	tools := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> topP [
	^ topP
]

{ #category : #accessing }
GtLOpenAIResponse >> topP: anObject [
	topP := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> truncation [
	^ truncation
]

{ #category : #accessing }
GtLOpenAIResponse >> truncation: anObject [
	truncation := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> usage [
	^ usage
]

{ #category : #accessing }
GtLOpenAIResponse >> usage: anObject [
	usage := anObject
]

{ #category : #accessing }
GtLOpenAIResponse >> user [
	^ user
]

{ #category : #accessing }
GtLOpenAIResponse >> user: anObject [
	user := anObject
]
