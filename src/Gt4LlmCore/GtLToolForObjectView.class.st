"
I return the remote phlow view specification for a stored object and view selector.
"
Class {
	#name : #GtLToolForObjectView,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForObjectView >> description [
	^ 'Returns a phlow view for an object given an object id and a method name'
]

{ #category : #accessing }
GtLToolForObjectView >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLToolForObjectView >> name [
	^ 'getViewContent'
]

{ #category : #accessing }
GtLToolForObjectView >> objectIdDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Object Id';
		accessor: #objectId;
		beRequired
]

{ #category : #private }
GtLToolForObjectView >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments objectId viewSelector object phlowView method |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].

	objectId := arguments at: 'objectId'.
	viewSelector := (arguments at: 'viewSelector') asSymbol.

	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new 
			missingModelName: 'objectStorage' ].

	object := anExecutionContext objectStorage
			objectAt: objectId
			ifPresent: [ :storedObject | storedObject ]
			ifAbsent: [ ^ GtLMissingDomainObject new objectName: objectId ].

	[ GtProcessStackOverflowChecker currentCheckerClass
		checkDuring: [ phlowView := GtPhlowView empty
					on: object
					perform: viewSelector
					withContext: GtPhlowContext new ].
	method := object class lookupSelector: viewSelector ]
		on: Error
		do: [ :r | ^ GtLExceptionDomainObject freeze: r ].

	method ifNil: [ 
		^ GtLMissingDomainObject new objectName: viewSelector ].
	
	^ GtLPhlowViewDomainObject
			phlowView: phlowView
			viewMethodClassName: method methodClass name
			viewMethodSourceCode: method sourceCode
]

{ #category : #accessing }
GtLToolForObjectView >> viewSelectorDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'View Selector';
		accessor: #viewSelector;
		beRequired
]
