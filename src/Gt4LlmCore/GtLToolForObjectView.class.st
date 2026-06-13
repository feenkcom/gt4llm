"
I return the remote phlow view specification for a stored object and view selector.
"
Class {
	#name : #GtLToolForObjectView,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForObjectView >> description [
	^ 'Returns a phlow view for an object given an object id and a method name'
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
	| arguments objectId viewSelector object |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].

	objectId := (arguments at: 'objectId') trimBoth.
	objectId ifEmpty: [ 
		^ GtLMissingDomainObject new objectName: 'objectId' ].
	
	viewSelector := (arguments at: 'viewSelector') trimBoth asSymbol.
	viewSelector ifEmpty: [ 
		^ GtLMissingDomainObject new objectName: 'viewSelector' ].

	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new 
			missingModelName: 'objectStorage' ].

	object := anExecutionContext objectStorage
			objectAt: objectId
			ifPresent: [ :storedObject | storedObject ]
			ifAbsent: [ 
				^ GtLMissingDomainObject new objectName: objectId ].

	^ (object gtLlmPhlowViewExtractor
			viewSelector: viewSelector)
				phlowViewDomainObjectOnError: [ :anError | anError ]
]

{ #category : #accessing }
GtLToolForObjectView >> viewSelectorDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'View Selector';
		accessor: #viewSelector;
		beRequired
]
