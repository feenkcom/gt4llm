Class {
	#name : #GtLWrappedModel,
	#superclass : #GtLBasicModel,
	#instVars : [
		'name',
		'model'
	],
	#category : #Gt4LlmCore
}

{ #category : #adding }
GtLWrappedModel >> addContentOneLineSummaryTo: aStringStream [
	self subclassResponsibility
]

{ #category : #adding }
GtLWrappedModel >> addContentTo: aDictionary [
	self subclassResponsibility
]

{ #category : #adding }
GtLWrappedModel >> addInstructionsTo: aMessageInstructions [
	self subclassResponsibility
]

{ #category : #adding }
GtLWrappedModel >> contentOneLineMultiLabelSummaryWith: aBuilder [
	aBuilder newTextFromStringStream: [ :aWriteStream | 
		self addContentOneLineSummaryTo: aWriteStream ]
]

{ #category : #accessing }
GtLWrappedModel >> description [
	^ model gtDisplayString
]

{ #category : #views }
GtLWrappedModel >> gtExportedJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON string';
		priority: 12;
		object: [ | object |
			object := NeoJSONObject new.
			self addContentTo: object.
			object ];
		view: #gtJsonFor:
]

{ #category : #'gt - inspector' }
GtLWrappedModel >> gtInspectorTargetModels [
	^ {self . model}
]

{ #category : #'gt - inspector' }
GtLWrappedModel >> gtViewContentDictionaryFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
			title: 'Result data';
			priority: 11;
			object: [ 
				| content |
				content := OrderedDictionary new.
				self addContentTo: content.
				content ];
			view: #gtTreeFor:
]

{ #category : #ui }
GtLWrappedModel >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
			streamContents: [ :aStream | 
				aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
				model
					ifNotNil: [ :aModel | 
						aStream
							nextPutAll: (GtPhlowViewsCollector new
									fromObject: aModel;
									pragmaNames: GtLSettings messageViewPragmaNames;
									collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #accessing }
GtLWrappedModel >> model [
	^ model
]

{ #category : #accessing }
GtLWrappedModel >> model: anObject [ 
	model := anObject
]

{ #category : #accessing }
GtLWrappedModel >> name [
	^ name
]

{ #category : #accessing }
GtLWrappedModel >> name: aString [ 
	name := aString 
]

{ #category : #serialization }
GtLWrappedModel >> serializeToLlmJsonObject [
	| wrapperObject |
	wrapperObject := NeoJSONObject new.
	self addContentTo: wrapperObject.
	
	^ (wrapperObject at: name)
]
