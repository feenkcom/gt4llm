"
I return the remote phlow view specification for a stored object and view selector.
"
Class {
	#name : #GtLToolForObjectView,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForObjectView >> description [
	^ 'Returns a phlow view for an object given an object id and a method name'
]

{ #category : #accessing }
GtLToolForObjectView >> name [
	^ 'getViewContent'
]

{ #category : #magritte }
GtLToolForObjectView >> parametersDescription [
	^ #('objectId' 'viewSelector')
]

{ #category : #execution }
GtLToolForObjectView >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments objectId viewSelector object viewSpecification phlowView |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	
	objectId := arguments
		at: 'objectId'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'objectId' ].
	viewSelector := arguments
		at: 'viewSelector'
		ifPresent: [ :each | each asSymbol ]
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'viewSelector' ].
	
	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new
				missingModelName: 'objectStorage' ].
				
	object := anExecutionContext objectStorage
		objectAt: objectId
		ifPresent: [ :storedObject | storedObject ]
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: objectId ].
		
	GtProcessStackOverflowChecker currentCheckerClass
		checkDuring: [ 
			phlowView := GtPhlowView empty
					on: object
					perform: viewSelector
					withContext: GtPhlowContext new ].
		
	^ GtLPhlowViewDomainObject new
			phlowView: phlowView
]
