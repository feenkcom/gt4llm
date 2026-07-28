Class {
	#name : #GtLDataSourceParser,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #private }
GtLDataSourceParser >> inputModelFrom: aString [
	"Convert the receiver's text in to the appropriate model.
	This needs a proper conversion process."
	| jsonObject |

	jsonObject := [ (NeoJSONReader on: aString readStream) next ]
		on: Error
		do: [ :ex | aString ].
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
	self error: 'Unrecognised input text format'.
]

{ #category : #accessing }
GtLDataSourceParser >> model [
	^ model
]

{ #category : #accessing }
GtLDataSourceParser >> model: anObject [
	model := anObject
]
