"
Abstract explicit reason for why an object was stored in GtLObjectStorage.
"
Class {
	#name : #GtLStoredObjectReason,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Object Storage'
}

{ #category : #printing }
GtLStoredObjectReason >> asReasonString [
	^ self subclassResponsibility
]

{ #category : #printing }
GtLStoredObjectReason >> gtDisplayOn: aStream [
	aStream nextPutAll: self asReasonString
]

{ #category : #'gt extensions' }
GtLStoredObjectReason >> gtInspectorTargetModels [
	^ #()
]

{ #category : #'gt extensions' }
GtLStoredObjectReason >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
		streamContents: [ :aStream |
			aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
			self gtInspectorTargetModels do: [ :eachTargetModel |
				aStream nextPutAll: (GtPhlowViewsCollector new
					fromObject: eachTargetModel;
					pragmaNames: GtLSettings messageViewPragmaNames;
					context: aPhlowContext;
					collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #printing }
GtLStoredObjectReason >> printOn: aStream [
	super printOn: aStream.
	aStream << ' (' << self asReasonString << ')'
]
