Class {
	#name : #GtLlmObjectTutor,
	#superclass : #GtLlmTutor,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> chatOn: anObject [
	| chat |
	chat := self createChat onInstance: (self serializerFor: anObject).


	chat provider addTool: (self methodsToolOn: anObject).
	chat provider addTool: (self methodToolOn: anObject).

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> defaultDescription [
	^ 'You are an assistant for objects in Glamorous Toolkit.'
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> methodToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectMethod';
		parameters: {'methodName'};
		description: 'Gets a method by name from the object and returns its source code.';
		block: [ :functionCall | 
			functionCall arguments
				at: 'methodName'
				ifPresent: [ :methodName | 
					anObject class allMethods
						detect: [ :aMethod | aMethod selector = methodName ]
						ifFound: #sourceCode
						ifNone: [ 'Method not found' ] ]
				ifAbsent: [ 'Method not found' ] ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> methodsToolOn: anObject [
	^ GtLlmFunctionTool new
		name: 'getObjectViews';
		parameters: {};
		description: 'Gets a list of the object’s views.';
		block: [ :functionCall | 
			Character cr
				join: ((Pragma
						allNamed: #gtView
						from: anObject class
						to: Object) collect: #methodSelector) ]
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> phlowInstructionSection [
	<gtLlmInstructionSection>
	^ GtLlmInstructionSection new
		title: 'Phlow views';
		body: 'Phlow is a framework for creating various views on the object inspector in Glamorous Toolkit. What follows are some examples for views that can be created using Phlow.

Lists:
```
gtListFor: aView
	<gtView>
	^ aView list
		title: ''My list view'';
		priority: 1;
		items: [ {1. 2. 3} ];
		itemText: #asString
```

Columned lists:
```
gtColumnedListFor: aView
	<gtView>
	^ aView columnedList
		title: ''My columned list view'';
		priority: 1;
		items: [ {1. 2. 3} ];
		column: ''Number'' text: #yourself;
		column: ''Double'' text: [:aNumber | aNumber * 2 ]
```
'
]

{ #category : #'as yet unclassified' }
GtLlmObjectTutor >> serializerFor: anObject [
	^ GtLlmSerializableValueHolder new
		name: 'Object';
		content: anObject;
		serializer: [ :aModel | GtLlmValueSerializer new serializeValue: aModel ];
		updater: [ :object :aString |
			"not actually a good idea"
			object readFromString: aString ]
]
