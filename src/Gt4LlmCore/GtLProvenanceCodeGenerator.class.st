Class {
	#name : #GtLProvenanceCodeGenerator,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Object Storage'
}

{ #category : #private }
GtLProvenanceCodeGenerator >> appendProvenanceEvaluationsFrom: aNode visited: visitedCalls on: aStream [
	| callNode call entry |
	callNode := aNode children
			ifEmpty: [ ^ self ]
			ifNotEmpty: [ :children | children first ].
	call := callNode target.
	(visitedCalls includes: call) ifTrue: [ ^ self ].
	visitedCalls add: call.
	callNode children
		do: [ :each | 
			self
				appendProvenanceEvaluationsFrom: each
				visited: visitedCalls
				on: aStream ].
	entry := aNode target.
	(entry reason isKindOf: GtLStoredObjectCodeExecutionReason)
		ifTrue: [ aStream nextPut: entry ]
]

{ #category : #private }
GtLProvenanceCodeGenerator >> bindingIdsFor: someBindings [
	| bindingIds |
	bindingIds := OrderedDictionary new.
	someBindings
		do: [ :each | 
			| name node |
			name := (each name ifNil: [ '' ]) asString.
			node := OCParser parseFaultyExpression: name.
			(node isVariable
				and: [ node isPseudoVariable not and: [ node name asString = name ] ])
				ifTrue: [ bindingIds at: name put: each objectId asString ] ].
	^ bindingIds
]

{ #category : #private }
GtLProvenanceCodeGenerator >> evaluationEntriesFrom: aTree [
	| visitedCalls |
	visitedCalls := IdentitySet new.
	^ Array
		streamContents: [ :aStream | 
			self
				appendProvenanceEvaluationsFrom: aTree
				visited: visitedCalls
				on: aStream ]
]

{ #category : #private }
GtLProvenanceCodeGenerator >> resultNamesFrom: bindingsByStep [
	| resultNames |
	resultNames := Dictionary new.
	bindingsByStep
		do: [ :bindings | 
			bindings
				keysAndValuesDo: [ :name :id | resultNames at: id ifAbsentPut: [ name ] ] ].
	^ resultNames
]

{ #category : #generating }
GtLProvenanceCodeGenerator >> scriptFor: someEntries [
	| bindingsByStep resultNames availableResults |
	bindingsByStep := someEntries
			collect: [ :entry | self bindingIdsFor: entry reason provenanceBindings ].
	resultNames := self resultNamesFrom: bindingsByStep.
	availableResults := Dictionary new.
	^ String
		streamContents: [ :aStream | 
			someEntries
				withIndexDo: [ :entry :index | 
					| id resultName |
					id := entry idString36.
					resultName := index = someEntries size
							ifFalse: [ resultNames at: id ifAbsent: [ 'result' , index asString ] ].
					self
						writeProvenanceInputs: (bindingsByStep at: index)
						using: availableResults
						on: aStream.
					self
						writeInlineProvenance: entry
						result: resultName
						on: aStream.
					resultName
						ifNotNil: [ availableResults at: id put: resultName.
							aStream
								cr;
								cr ] ] ]
]

{ #category : #generating }
GtLProvenanceCodeGenerator >> scriptForTree: aTree [
	^ self scriptFor: (self evaluationEntriesFrom: aTree)
]

{ #category : #private }
GtLProvenanceCodeGenerator >> writeInlineProvenance: anEntry result: resultName on: aStream [
	| ast source bodyStart lastStatement trailing expressionStart |
	source := anEntry reason code.
	ast := OCParser parseFaultyExpression: source.
	ast isFaulty
		ifTrue: [ aStream
				nextPutAll: 'self error: ''The recorded evaluation has a syntax error''.'.
			^ self ].
	bodyStart := (ast isSequence and: [ ast hasTemporaries ])
			ifTrue: [ ast rightBar + 1 ]
			ifFalse: [ 1 ].
	resultName
		ifNil: [ aStream nextPutAll: (source copyFrom: bodyStart to: source size) trimLeft.
			^ self ].
	lastStatement := ast isSequence
			ifTrue: [ ast statements ifEmpty: [ nil ] ifNotEmpty: [ :statements | statements last ] ]
			ifFalse: [ ast ].
	lastStatement
		ifNil: [ aStream
				nextPutAll: (source copyFrom: bodyStart to: source size) trimLeft;
				cr;
				nextPutAll: resultName;
				nextPutAll: ' := nil.'.
			^ self ].
	expressionStart := lastStatement isReturn
			ifTrue: [ lastStatement start + 1 ]
			ifFalse: [ lastStatement start ].
	trailing := source copyFrom: lastStatement stop + 1 to: source size.
	aStream
		nextPutAll: (source copyFrom: bodyStart to: lastStatement start - 1) trimLeft;
		nextPutAll: resultName;
		nextPutAll: ' := ';
		nextPutAll: (source copyFrom: expressionStart to: lastStatement stop) trimLeft.
	((trailing trimLeft beginsWith: '.')
		or: [ ast isSequence
				and: [ ast periods anySatisfy: [ :each | each > lastStatement stop ] ] ])
		ifFalse: [ aStream nextPut: $. ].
	aStream nextPutAll: trailing
]

{ #category : #private }
GtLProvenanceCodeGenerator >> writeProvenanceInputs: bindingIds using: availableResults on: aStream [
	bindingIds
		keysAndValuesDo: [ :name :objectId | 
			| resultName |
			resultName := availableResults at: objectId ifAbsent: [ nil ].
			resultName = name
				ifFalse: [ aStream
						nextPutAll: name;
						nextPutAll: ' := '.
					resultName
						ifNil: [ aStream nextPutAll: '(objectStorage objectAt: '.
							objectId storeOn: aStream.
							aStream nextPut: $) ]
						ifNotNil: [ aStream nextPutAll: resultName ].
					aStream
						nextPut: $.;
						cr ] ]
]
