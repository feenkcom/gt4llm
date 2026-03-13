Class {
	#name : #GTLDataViewWrapperModel,
	#superclass : #GtLBasicModel,
	#instVars : [
		'targetObject',
		'mainDataView'
	],
	#category : #Gt4LlmCore
}

{ #category : #'gt - inspector' }
GTLDataViewWrapperModel >> gtInspectorTargetModels [
	^{self. mainDataView. targetObject}
]

{ #category : #'gt - inspector' }
GTLDataViewWrapperModel >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
			streamContents: [ :aStream | 
				aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
				targetObject
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
GTLDataViewWrapperModel >> mainDataView [
	^mainDataView
]

{ #category : #accessing }
GTLDataViewWrapperModel >> mainDataView: anObject [
	mainDataView := anObject
]

{ #category : #serialization }
GTLDataViewWrapperModel >> serializeToAnthropicResponseOutput [
	^ mainDataView  serializeToAnthropicResponseOutput
]

{ #category : #serialization }
GTLDataViewWrapperModel >> serializeToOpenAIResponseOutput [
	^ mainDataView  serializeToOpenAIResponseOutput
]

{ #category : #accessing }
GTLDataViewWrapperModel >> targetDataView: aCollection [
	self mainDataView: (GtLCompositeDataView new 
		addDataViews: aCollection)
]

{ #category : #accessing }
GTLDataViewWrapperModel >> targetObject [
	^targetObject
]

{ #category : #accessing }
GTLDataViewWrapperModel >> targetObject: anObject [
	targetObject := anObject
]
