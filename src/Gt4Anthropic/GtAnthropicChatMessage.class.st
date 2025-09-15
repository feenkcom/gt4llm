Class {
	#name : #GtAnthropicChatMessage,
	#superclass : #GtLlmChatMessage,
	#instVars : [
		'stopReason',
		'stopSequence',
		'type',
		'usage'
	],
	#category : #Gt4Anthropic
}

{ #category : #'as yet unclassified' }
GtAnthropicChatMessage class >> defaultRole [
	^ nil
]

{ #category : #accessing }
GtAnthropicChatMessage class >> leJsonV4Name [

	^ #gtAnthropicChatMessage
]

{ #category : #'as yet unclassified' }
GtAnthropicChatMessage class >> serializationProperties [
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
GtAnthropicChatMessage >> action [
	^ self toolCalls
		ifEmpty: [ super action ]
		ifNotEmpty: [ :toolCalls | toolCalls first humanReadable ]
]

{ #category : #'as yet unclassified' }
GtAnthropicChatMessage >> actionModel [
	^ self toolCalls ifEmpty: [ nil ] ifNotEmpty: [ :toolCalls | toolCalls first ]
]

{ #category : #'as yet unclassified' }
GtAnthropicChatMessage >> contentText [
	^ (content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content
						select: [ :aValue | (aValue at: #type) = 'text' ]
						thenCollect: [ :aValue | (aValue at: #text) ifNil: [ '' ] ]) ]
]

{ #category : #'as yet unclassified' }
GtAnthropicChatMessage >> serialize [
	^ {'role' -> self role.
		'content' -> self content} asDictionary
]

{ #category : #accessing }
GtAnthropicChatMessage >> stopReason [
	^ stopReason
]

{ #category : #accessing }
GtAnthropicChatMessage >> stopReason: anObject [
	stopReason := anObject
]

{ #category : #accessing }
GtAnthropicChatMessage >> stopSequence [
	^ stopSequence
]

{ #category : #accessing }
GtAnthropicChatMessage >> stopSequence: anObject [
	stopSequence := anObject
]

{ #category : #'as yet unclassified' }
GtAnthropicChatMessage >> toolCalls [
	^ (content isKindOf: String)
		ifTrue: [ {} ]
		ifFalse: [ content
				select: [ :aValue | (aValue at: #type) = 'tool_use' ]
				thenCollect: [ :aDict | 
					GtLlmFunctionToolCall new
						id: (aDict at: 'id');
						name: (aDict at: 'name');
						arguments: (aDict at: 'input') ] ]
]

{ #category : #accessing }
GtAnthropicChatMessage >> type [
	^ type
]

{ #category : #accessing }
GtAnthropicChatMessage >> type: anObject [
	type := anObject
]

{ #category : #accessing }
GtAnthropicChatMessage >> usage [
	^ usage
]

{ #category : #accessing }
GtAnthropicChatMessage >> usage: anObject [
	usage := anObject
]
