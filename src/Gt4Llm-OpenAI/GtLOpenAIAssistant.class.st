Class {
	#name : #GtLOpenAIAssistant,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'createdAt',
		'name',
		'description',
		'model',
		'instructions',
		'tools',
		'toolResources'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIAssistant class >> leJsonV4Name [

	^ #gtOpenAIAssistant
]

{ #category : #accessing }
GtLOpenAIAssistant class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#name -> #name.
		#description -> #description.
		#model -> #model.
		#instructions -> #instructions.
		#tools -> #tools.
		#tool_resources -> #toolResources}
]

{ #category : #accessing }
GtLOpenAIAssistant >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIAssistant >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIAssistant >> description [
	^ description
]

{ #category : #accessing }
GtLOpenAIAssistant >> description: anObject [
	description := anObject
]

{ #category : #'gt - extensions' }
GtLOpenAIAssistant >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Tutor instructions';
		priority: 5;
		text: [ self instructions ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #accessing }
GtLOpenAIAssistant >> gtToolsFor: aView [
	<gtView>
	^ aView list
		title: 'Tools';
		priority: 2;
		items: [ self tools ];
		itemText: #type
]

{ #category : #accessing }
GtLOpenAIAssistant >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIAssistant >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIAssistant >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLOpenAIAssistant >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLOpenAIAssistant >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIAssistant >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAIAssistant >> name [
	^ name
]

{ #category : #accessing }
GtLOpenAIAssistant >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLOpenAIAssistant >> serialize [
	| serialized |
	serialized := super serialize.
	serialized at: #tools put: ((serialized at: #tools) collect: #serialize).
	^ serialized
]

{ #category : #accessing }
GtLOpenAIAssistant >> toolResources [
	^ toolResources
]

{ #category : #accessing }
GtLOpenAIAssistant >> toolResources: anObject [
	toolResources := anObject
]

{ #category : #accessing }
GtLOpenAIAssistant >> tools [
	^ tools
]

{ #category : #accessing }
GtLOpenAIAssistant >> tools: anObject [
	tools := anObject collect: [ :aValue | GtLlmTool from: aValue ]
]
