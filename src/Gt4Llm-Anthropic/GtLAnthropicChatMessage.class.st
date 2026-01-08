Class {
	#name : #GtLAnthropicChatMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'stopReason',
		'stopSequence',
		'type',
		'usage'
	],
	#category : #'Gt4Llm-Anthropic'
}

{ #category : #accessing }
GtLAnthropicChatMessage class >> leJsonV4Name [
	^ #gtLAnthropicChatMessage
]

{ #category : #'as yet unclassified' }
GtLAnthropicChatMessage class >> serializationProperties [
	^ {#content -> #content.
		#id -> #id.
		#model -> #model.
		#role -> #role.
		#stop_reason -> #stopReason.
		#stop_sequence -> #stopSequence.
		#type -> #type.
		#usage -> #usage}
]

{ #category : #'as yet unclassified' }
GtLAnthropicChatMessage >> action [
	^ self toolCalls
		ifEmpty: [ super action ]
		ifNotEmpty: [ :toolCalls | toolCalls first humanReadable ]
]

{ #category : #'as yet unclassified' }
GtLAnthropicChatMessage >> actionModel [
	^ self toolCalls ifEmpty: [ nil ] ifNotEmpty: [ :toolCalls | toolCalls first ]
]

{ #category : #'as yet unclassified' }
GtLAnthropicChatMessage >> contentText [
	^ '' "(content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content
						select: [ :aValue | (aValue at: #type) = 'text' ]
						thenCollect: [ :aValue | (aValue at: #text) ifNil: [ '' ] ]) ]"
]

{ #category : #'as yet unclassified' }
GtLAnthropicChatMessage >> serialize [
	^ {'role' -> self role.
		'content' -> self content} asDictionary
]

{ #category : #accessing }
GtLAnthropicChatMessage >> stopReason [
	^ stopReason
]

{ #category : #accessing }
GtLAnthropicChatMessage >> stopReason: anObject [
	stopReason := anObject
]

{ #category : #accessing }
GtLAnthropicChatMessage >> stopSequence [
	^ stopSequence
]

{ #category : #accessing }
GtLAnthropicChatMessage >> stopSequence: anObject [
	stopSequence := anObject
]

{ #category : #'as yet unclassified' }
GtLAnthropicChatMessage >> toolCalls [
	^ (content isKindOf: String)
		ifTrue: [ {} ]
		ifFalse: [ content
				select: [ :aValue | (aValue at: #type) = 'tool_use' ]
				thenCollect: [ :aDict | 
					GtLFunctionToolCall new
						id: (aDict at: 'id');
						name: (aDict at: 'name');
						arguments: (aDict at: 'input') ] ]
]

{ #category : #accessing }
GtLAnthropicChatMessage >> type [
	^ type
]

{ #category : #accessing }
GtLAnthropicChatMessage >> type: anObject [
	type := anObject
]

{ #category : #accessing }
GtLAnthropicChatMessage >> usage [
	^ usage
]

{ #category : #accessing }
GtLAnthropicChatMessage >> usage: anObject [
	usage := anObject
]
