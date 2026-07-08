"
Represents an OpenAI-compatible message payload backed by raw JSON data.
"
Class {
	#name : #GtLOpenAiMessagesEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOpenAiMessagesEntity >> content [
	^ (self rawData at: 'content') collect: [ :each | GtLOpenAiContentEntity new rawData: each ]
]

{ #category : #ui }
GtLOpenAiMessagesEntity >> gtContentFor: aView [
	<gtView>
	| content |

	content := [ self content ]
		on: Error
		do: [ :ex | nil ].
	content ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Content';
		priority: 10;
		items: [ self content ]
]

{ #category : #accessing }
GtLOpenAiMessagesEntity >> role [
	^ self rawData at: 'role'
]
