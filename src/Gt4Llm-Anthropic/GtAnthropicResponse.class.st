Class {
	#name : #GtAnthropicResponse,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'model',
		'type',
		'role',
		'content',
		'stopSequence',
		'stopReason',
		'usage',
		'toolCalls',
		'requestResponse'
	],
	#category : 'Gt4Llm-Anthropic-Client'
}

{ #category : #serialization }
GtAnthropicResponse class >> serializationProperties [
	^ {#id -> #id.
		#model -> #model.
		#type -> #type.
		#role -> #role.
		#content -> #content.
		#stop_sequence -> #stopSequence.
		#stop_reason -> #stopReason.
		#usage -> #usage.}
]

{ #category : #accessing }
GtAnthropicResponse >> content [
	^ content
]

{ #category : #accessing }
GtAnthropicResponse >> content: anObject [
	content := anObject.
	toolCalls := nil.
]

{ #category : #testing }
GtAnthropicResponse >> hasToolCalls [
	^ self toolCalls isNotEmpty
]

{ #category : #accessing }
GtAnthropicResponse >> id [
	^ id
]

{ #category : #accessing }
GtAnthropicResponse >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtAnthropicResponse >> model [
	^ model
]

{ #category : #accessing }
GtAnthropicResponse >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtAnthropicResponse >> requestResponse [
	^ requestResponse
]

{ #category : #accessing }
GtAnthropicResponse >> requestResponse: anObject [
	requestResponse := anObject
]

{ #category : #accessing }
GtAnthropicResponse >> role [
	^ role
]

{ #category : #accessing }
GtAnthropicResponse >> role: anObject [
	role := anObject
]

{ #category : #accessing }
GtAnthropicResponse >> stopReason [
	^ stopReason
]

{ #category : #accessing }
GtAnthropicResponse >> stopReason: anObject [
	stopReason := anObject
]

{ #category : #accessing }
GtAnthropicResponse >> stopSequence [
	^ stopSequence
]

{ #category : #accessing }
GtAnthropicResponse >> stopSequence: anObject [
	stopSequence := anObject
]

{ #category : #accessing }
GtAnthropicResponse >> toolCalls [
	<return: #Array of: #GtLFunctionToolCall>
	^ toolCalls
		ifNil: [ toolCalls := (self content
					select: [ :aDict | (aDict at: 'type') = 'tool_use' ]
					thenCollect: [ :aDict | 
						GtLFunctionToolCall new
							rawData: aDict;
							id: (aDict at: 'id');
							name: (aDict at: 'name');
							rawArguments: (aDict at: 'input') ]) as: Array ]
]

{ #category : #accessing }
GtAnthropicResponse >> toolCalls: anObject [
	toolCalls := anObject
]

{ #category : #accessing }
GtAnthropicResponse >> type [
	^ type
]

{ #category : #accessing }
GtAnthropicResponse >> type: anObject [
	type := anObject
]

{ #category : #accessing }
GtAnthropicResponse >> usage [
	^ usage
]

{ #category : #accessing }
GtAnthropicResponse >> usage: anObject [
	usage := anObject
]
