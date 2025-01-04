"
Based on <https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion>.
"
Class {
	#name : #GtOllamaGenerateResponseClient,
	#superclass : #GtLlmEndpointClient,
	#instVars : [
		'model',
		'prompt',
		'suffix',
		'images',
		'format',
		'options',
		'system',
		'template',
		'stream',
		'raw',
		'keep_alive'
	],
	#category : #'Gt4Ollama-Client'
}

{ #category : #'as yet unclassified' }
GtOllamaGenerateResponseClient >> entity [
	| entity |

	entity := Dictionary new.
	entity
		at: 'model' put: model;
		at: 'prompt' put: prompt.
	format ifNotNil: [ entity at: 'format' put: format ].
	images ifNotNil: [ entity at: 'images' put: images ].
	keep_alive ifNotNil: [ entity at: 'keep_alive' put: keep_alive ].
	options ifNotNil: [ entity at: 'options' put: options ].
	suffix ifNotNil: [ entity at: 'suffix' put: suffix ].
	system ifNotNil: [ entity at: 'system' put: system ].
	template ifNotNil: [ entity at: 'template' put: template ].
	^ entity
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> format [
	"The format to return a response in. Format can be json or a JSON schema"

	^ format
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> images [
	"(optional) a list of base64-encoded images (for multimodal models such as llava)"

	^ images
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> images: anObject [
	images := anObject
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> keep_alive [
	"Controls how long the model will stay loaded into memory following the request (default: 5m)"

	^ keep_alive
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> keep_alive: anObject [
	keep_alive := anObject
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> model [
	^ model
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> options [
	"Additional model parameters listed in the documentation for the Modelfile such as temperature"

	^ options
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> options: anObject [
	options := anObject
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> prompt [
	"The prompt to generate a response for"

	^ prompt
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> prompt: aString [

	prompt := aString
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> raw [
	"If true no formatting will be applied to the prompt. You may choose to use the raw parameter if you are specifying a full templated prompt in your request to the API"

	^ raw
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> raw: aBoolean [

	raw := aBoolean
]

{ #category : #'as yet unclassified' }
GtOllamaGenerateResponseClient >> request [

	^ self stream 
		ifTrue: [ self client postStreaming: '/generate' withEntity: self entity ]
		ifFalse: [ self client post: '/generate' withEntity: self entity ]
]

{ #category : #'as yet unclassified' }
GtOllamaGenerateResponseClient >> serializationClass [
	^ GtOllamaResponseMessage
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> stream [
	"If false the response will be returned as a single response object, rather than a stream of objects"

	^ stream ifNil: [ true ]
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> stream: aBoolean [

	stream := aBoolean
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> suffix [
	"The text after the model response"

	^ suffix
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> suffix: anObject [
	suffix := anObject
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> system [
	"System message to (overrides what is defined in the Modelfile)"

	^ system
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> system: anObject [
	system := anObject
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> template [
	"The prompt template to use (overrides what is defined in the Modelfile)"

	^ template
]

{ #category : #accessing }
GtOllamaGenerateResponseClient >> template: anObject [
	template := anObject
]
