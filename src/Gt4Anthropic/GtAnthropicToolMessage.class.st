Class {
	#name : #GtAnthropicToolMessage,
	#superclass : #GtLlmUserMessage,
	#instVars : [
		'contentText'
	],
	#category : #'Gt4Anthropic-Models'
}

{ #category : #'as yet unclassified' }
GtAnthropicToolMessage >> action [
	^ 'Tool result'
]

{ #category : #'as yet unclassified' }
GtAnthropicToolMessage >> actionModel [
	^ self contentText
]

{ #category : #'as yet unclassified' }
GtAnthropicToolMessage >> content [
	^ {{'type' -> 'tool_result'.
			'tool_use_id' -> id.
			'content' -> contentText} asDictionary}
]

{ #category : #accessing }
GtAnthropicToolMessage >> contentText [
	^ contentText
]

{ #category : #accessing }
GtAnthropicToolMessage >> contentText: anObject [
	contentText := anObject
]

{ #category : #'as yet unclassified' }
GtAnthropicToolMessage >> gtJsonFor: aView context: aContext [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtAnthropicToolMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtAnthropicToolMessage >> senderText [
	^ 'Tool'
]
