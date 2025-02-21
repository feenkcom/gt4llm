Class {
	#name : #GtOpenAIAssistant,
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
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIAssistant class >> serializationProperties [
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
GtOpenAIAssistant >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIAssistant >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIAssistant >> description [
	^ description
]

{ #category : #accessing }
GtOpenAIAssistant >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtOpenAIAssistant >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Tutor instructions';
		priority: 5;
		text: [ self instructions ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #accessing }
GtOpenAIAssistant >> gtToolsFor: aView [
	<gtView>
	^ aView list
		title: 'Tools';
		priority: 2;
		items: [ self tools ];
		itemText: #type
]

{ #category : #accessing }
GtOpenAIAssistant >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIAssistant >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIAssistant >> instructions [
	^ instructions
]

{ #category : #accessing }
GtOpenAIAssistant >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtOpenAIAssistant >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIAssistant >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIAssistant >> name [
	^ name
]

{ #category : #accessing }
GtOpenAIAssistant >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtOpenAIAssistant >> serialize [
	| serialized |
	serialized := super serialize.
	serialized at: #tools put: ((serialized at: #tools) collect: #serialize).
	^ serialized
]

{ #category : #accessing }
GtOpenAIAssistant >> toolResources [
	^ toolResources
]

{ #category : #accessing }
GtOpenAIAssistant >> toolResources: anObject [
	toolResources := anObject
]

{ #category : #accessing }
GtOpenAIAssistant >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIAssistant >> tools: anObject [
	tools := anObject collect: [ :aValue | GtLlmTool from: aValue ]
]
