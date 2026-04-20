Class {
	#name : #GtLWrappedModel,
	#superclass : #GtLBasicModel,
	#instVars : [
		'name',
		'model',
		'cachedMainDataView'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #adding }
GtLWrappedModel >> addContentOneLineSummaryTo: aStringStream [
	self subclassResponsibility
]

{ #category : #adding }
GtLWrappedModel >> addInstructionsTo: aMessageInstructions [

]

{ #category : #serialization }
GtLWrappedModel >> computeMainDataView [
	^(self llmDataViewsFor: GtLDataView new)
		dataKey: self name
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
		object: [ self mainDataView serializeToLlmPrimiteData ];
		view: #gtViewCondensedJsonStringFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			label: 'JSON'
			tooltip: 'Inspect JSON Object'
			action: [ :aButton | aButton phlow 
				spawnObject: self mainDataView 
					serializeToLlmPrimiteData llmJsonData asGtJson ]
]

{ #category : #'gt - inspector' }
GtLWrappedModel >> gtInspectorTargetModels [
	^ {self . model}
]

{ #category : #views }
GtLWrappedModel >> gtSpawnDataBlockFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Block';
		tooltip: 'Spawn the data block';
		action: [ :button | button phlow spawnObject: self mainDataView ]
]

{ #category : #views }
GtLWrappedModel >> gtSpawnDataViewFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Data';
		tooltip: 'Spawn the data view';
		action: [ :button | button phlow spawnObject: self mainDataView ]
]

{ #category : #views }
GtLWrappedModel >> gtSpawnModelFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		label: 'Model';
		tooltip: 'Spawn the model';
		action: [ :button | button phlow spawnObject: model ]
]

{ #category : #'gt - inspector' }
GtLWrappedModel >> gtViewContentDictionaryFor: aView [
	<gtView>
	^ aView forward
			title: 'Result data';
			priority: 11;
			object: [ 
				self mainDataView serializeToLlmPrimiteData ];
			view: #gtViewCondensedJsonDataFor:
]

{ #category : #views }
GtLWrappedModel >> gtViewLlmSerializationJSONFor: aView [
	<gtView>
	^ aView forward
		title: 'LLM JSON';
		priority: 40;
		object: [ self mainDataView serializeToLlmPrimiteData ];
		view: #gtViewSerializationJSONFor:
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

{ #category : #serialization }
GtLWrappedModel >> llmModelDataViewsFor: aDataView [
	self subclassResponsibility
]

{ #category : #serialization }
GtLWrappedModel >> mainDataView [
	^cachedMainDataView ifNil: [
		cachedMainDataView := self computeMainDataView ]
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
GtLWrappedModel >> serializeToAnthropicResponseOutput [
	^ self mainDataView  serializeToAnthropicResponseOutput
]

{ #category : #serialization }
GtLWrappedModel >> serializeToOllamaResponseOutput [
	^ self mainDataView  serializeToOllamaResponseOutput
]

{ #category : #serialization }
GtLWrappedModel >> serializeToOpenAIResponseOutput [
	^ self mainDataView  serializeToOpenAIResponseOutput
]
