Class {
	#name : #GtLInputModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'model'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLInputModel >> addContentOneLineSummaryTo: aStringStream [
	self subclassResponsibility
]

{ #category : #adding }
GtLInputModel >> addContentTo: aDictionary [
	self subclassResponsibility
]

{ #category : #adding }
GtLInputModel >> addInstructionsTo: aMessageInstructions [
	self subclassResponsibility
]

{ #category : #adding }
GtLInputModel >> contentOneLineMultiLabelSummaryWith: aBuilder [
	aBuilder newTextFromStringStream: [ :aWriteStream | 
		self addContentOneLineSummaryTo: aWriteStream ]
]

{ #category : #accessing }
GtLInputModel >> description [
	^ model gtDisplayString
]

{ #category : #views }
GtLInputModel >> gtExportedJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'Exported JSON';
		object: [ | object |
			object := NeoJSONObject new.
			self addContentTo: object.
			object ];
		view: #gtJsonFor:
]

{ #category : #'gt - inspector' }
GtLInputModel >> gtInspectorTargetModels [
	^ {self . model}
]

{ #category : #'gt - inspector' }
GtLInputModel >> gtViewContentDictionaryFor: aView [
	<gtView>
	^ aView forward
			title: 'Content Dictionary';
			object: [ 
				| content |
				content := OrderedDictionary new.
				self addContentTo: content.
				content ];
			view: #gtTreeFor:
]

{ #category : #accessing }
GtLInputModel >> model: anObject [ 
	model := anObject
]

{ #category : #accessing }
GtLInputModel >> name [
	^ name
]

{ #category : #accessing }
GtLInputModel >> name: aString [ 
	name := aString 
]

{ #category : #serialization }
GtLInputModel >> serializeModelToJsonString [
	"Return a JSON string that represents the domain object."
	| object |
	
	object := NeoJSONObject new.
	self addContentTo: object.
	
	^ NeoJSONWriter toStringPretty: (object at: name)
]

{ #category : #serialization }
GtLInputModel >> serializeToAnthropicResponseOutput [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: 'text' put: self serializeModelToJsonString;
			at: 'type' put: 'text';
			yourself}
]

{ #category : #serialization }
GtLInputModel >> serializeToOpenAIResponseOutput [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: #text put: self serializeModelToJsonString;
			at: #type put: #input_text;
			yourself}
]
