"
Represents an OpenAI-compatible content payload backed by raw JSON data.
"
Class {
	#name : #GtLOpenAiContentEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #ui }
GtLOpenAiContentEntity >> gtTextModelFor: aView [
	<gtView>
	| textModel |

	textModel := [ self textModel ]
		on: Error
		do: [ :ex | nil ].
	textModel ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Text Model';
		priority: 10;
		object: [ self textModel ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLOpenAiContentEntity >> jsonObject [
	^ (NeoJSONReader on: (self rawData at: 'text') readStream) next
]

{ #category : #accessing }
GtLOpenAiContentEntity >> text [

	^ self textModel model text
]

{ #category : #accessing }
GtLOpenAiContentEntity >> textModel [
	"Convert the receiver's text in to the appropriate model.
	This needs a proper conversion process."
	| jsonObject |

	jsonObject := self jsonObject.
	jsonObject isString ifTrue:
		[ ^ GtLWrappedObjectModel new
			model: (GtLString forString: jsonObject) ].
	jsonObject isDictionary ifTrue:
		[ jsonObject at: 'Markdown'
			ifPresent: [ :aDictionary |
				^ GtLMagritteBasedModel new
					name: 'Markdown';
					model: (GtLMarkdown content:
						(aDictionary at: 'content')) ] ].
	^ jsonObject
]

{ #category : #accessing }
GtLOpenAiContentEntity >> type [
	^ self rawData at: 'type'
]
