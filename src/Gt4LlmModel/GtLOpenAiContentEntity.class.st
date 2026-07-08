"
Represents an OpenAI-compatible content payload backed by raw JSON data.
"
Class {
	#name : #GtLOpenAiContentEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #ui }
GtLOpenAiContentEntity >> gtTextFor: aView [
	<gtView>
	| text |

	text := [ self text ]
		on: Error
		do: [ :ex | nil ].
	text ifNil: [ ^ aView empty ].
	^ aView text
		title: 'Text';
		priority: 10;
		text: [ self text ]
]

{ #category : #accessing }
GtLOpenAiContentEntity >> text [
	^ self rawData at: 'text'
]

{ #category : #accessing }
GtLOpenAiContentEntity >> type [
	^ self rawData at: 'type'
]
