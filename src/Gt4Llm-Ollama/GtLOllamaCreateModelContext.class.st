Class {
	#name : #GtLOllamaCreateModelContext,
	#superclass : #GtLEndpointContext,
	#instVars : [
		'name',
		'template',
		'license',
		'system',
		'messages',
		'parameters',
		'quantize'
	],
	#category : #'Gt4Llm-Ollama-Contexts'
}

{ #category : #accessing }
GtLOllamaCreateModelContext >> from [
	"The new model is derived from the current model"

	^ model name
]

{ #category : #initialization }
GtLOllamaCreateModelContext >> fromModelFile: anOllamaModelFile [
	| attributeMapping |

	attributeMapping := {
		'FROM' -> [ :value | value text = model name ifFalse: [ self error: 'File from (', value text asString, ') doesn''t match model name (', model name asString, ')' ] ].
		'LICENSE' -> [ :value | self license: value text ].
		'MESSAGE' -> [ :value | self messages add: { 'role' -> value text. 'message' -> value messageText } asDictionary ].
		'NAME' -> [ :value | self name: value text ].
		'PARAMETER' -> [ :value | self parameters at: value text put: value value ].
		'QUANTIZE' -> [ :value | self quantize: value text ].
		'SYSTEM' -> [ :value | self system: value text ].
		'TEMPLATE' -> [ :value | self template: value text ].
		} asDictionary.
	anOllamaModelFile directives do: [ :directive |
		(attributeMapping at: directive directiveKind) value: directive ].
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> license [
	^ license
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> license: aString [

	license := aString
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> messages [
	^ messages ifNil: [ messages := OrderedCollection new ]
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> messages: anArray [

	messages := anArray
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> name [
	^ name
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> name: aString [

	name := aString
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> parameters [
	^ parameters ifNil: [ parameters := Dictionary new ]
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> parameters: aDictionary [

	parameters := aDictionary
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> quantize [
	^ quantize
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> quantize: aString [

	quantize := aString
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> system [
	^ system
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> system: aString [

	system := aString
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> template [
	^ template
]

{ #category : #accessing }
GtLOllamaCreateModelContext >> template: aString [

	template := aString
]
