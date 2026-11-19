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
GtLProvenanceCodeGenerator >> provenanceBindingIdsForEvaluation: anEvaluation [
	| bindingIds |
	bindingIds := OrderedDictionary new.
	anEvaluation key reason provenanceBindings
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
GtLProvenanceCodeGenerator >> provenanceResultNamesFor: evaluations bindings: bindingsByStep [
	| preferredNames bindingIdsByName sourceNames reassignedNames resultNames |
	preferredNames := Dictionary new.
	bindingIdsByName := Dictionary new.
	sourceNames := Set with: 'objectStorage'.
	reassignedNames := Set with: 'objectStorage'.
	evaluations
		with: bindingsByStep
		do: [ :evaluation :bindings | 
			reassignedNames addAll: (self provenanceTemporariesOf: evaluation value).
			evaluation value
				nodesDo: [ :node | 
					node isVariable
						ifTrue: [ sourceNames add: node name asString.
							node isWrite ifTrue: [ reassignedNames add: node name asString ] ] ].
			bindings
				keysAndValuesDo: [ :name :id | 
					sourceNames add: name.
					preferredNames at: id ifAbsentPut: [ name ].
					(bindingIdsByName at: name ifAbsentPut: [ Set new ]) add: id ] ].
	resultNames := Dictionary new.
	evaluations allButLast
		withIndexDo: [ :evaluation :index | 
			| id name |
			id := evaluation key idString36.
			name := preferredNames at: id ifAbsent: [ nil ].
			(name isNil
				or: [ (reassignedNames includes: name) or: [ (bindingIdsByName at: name) size > 1 ] ])
				ifTrue: [ name := self
							uniqueProvenanceName: 'result' , index asString
							avoiding: sourceNames ].
			resultNames at: id put: name ].
	^ resultNames
]

{ #category : #private }
GtLProvenanceCodeGenerator >> provenanceTemporariesOf: anAst [
	^ anAst isSequence
		ifTrue: [ anAst temporaryNames collect: #asString ]
		ifFalse: [ #() ]
]

{ #category : #generating }
GtLProvenanceCodeGenerator >> scriptFor: someEntries [
	| evaluations bindingsByStep resultNames availableResults declaredNames body |
	evaluations := someEntries
			collect: [ :entry | entry -> (OCParser parseFaultyExpression: entry reason code) ].
	evaluations ifEmpty: [ ^ '' ].
	bindingsByStep := evaluations
			collect: [ :each | self provenanceBindingIdsForEvaluation: each ].
	resultNames := self
			provenanceResultNamesFor: evaluations
			bindings: bindingsByStep.
	availableResults := Dictionary new.
	declaredNames := OrderedCollection new.
	body := String
			streamContents: [ :aStream | 
				evaluations
					withIndexDo: [ :evaluation :index | 
						| resultName |
						resultName := resultNames at: evaluation key idString36 ifAbsent: [ nil ].
						self
							writeProvenanceInputs: (bindingsByStep at: index)
							using: availableResults
							declaredIn: declaredNames
							on: aStream.
						(self provenanceTemporariesOf: evaluation value)
							do: [ :name | 
								(declaredNames includes: name)
									ifTrue: [ aStream
											nextPutAll: name;
											nextPutAll: ' := nil.';
											cr ]
									ifFalse: [ declaredNames add: name ] ].
						self
							writeInlineProvenance: evaluation
							result: resultName
							on: aStream.
						resultName
							ifNotNil: [ declaredNames add: resultName.
								availableResults at: evaluation key idString36 put: resultName.
								aStream
									cr;
									cr ] ] ].
	declaredNames ifEmpty: [ ^ body ].
	^ String
		streamContents: [ :aStream | 
			aStream nextPutAll: '| '.
			declaredNames
				do: [ :each | 
					aStream
						nextPutAll: each;
						space ].
			aStream
				nextPut: $|;
				cr;
				cr;
				nextPutAll: body ]
]

{ #category : #generating }
GtLProvenanceCodeGenerator >> scriptForTree: aTree [
	^ self scriptFor: (self evaluationEntriesFrom: aTree)
]

{ #category : #private }
GtLProvenanceCodeGenerator >> uniqueProvenanceName: aName avoiding: occupiedNames [
	| name |
	name := aName.
	[ occupiedNames includes: name ] whileTrue: [ name := name , 'x' ].
	occupiedNames add: name.
	^ name
]

{ #category : #private }
GtLProvenanceCodeGenerator >> writeInlineProvenance: anEvaluation result: resultName on: aStream [
	| ast source bodyStart lastStatement trailing expressionStart |
	ast := anEvaluation value.
	ast isFaulty
		ifTrue: [ aStream
				nextPutAll: 'self error: ''The recorded evaluation has a syntax error''.'.
			^ self ].
	source := anEvaluation key reason code.
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
GtLProvenanceCodeGenerator >> writeProvenanceArgument: anObjectId using: availableResults on: aStream [
	| bindingId |
	bindingId := anObjectId asString.
	availableResults
		at: bindingId
		ifPresent: [ :resultName | aStream nextPutAll: resultName ]
		ifAbsent: [ aStream nextPutAll: '(objectStorage objectAt: '.
			bindingId storeOn: aStream.
			aStream nextPut: $) ]
]

{ #category : #private }
GtLProvenanceCodeGenerator >> writeProvenanceInputs: bindingIds using: availableResults declaredIn: declaredNames on: aStream [
	bindingIds
		keysAndValuesDo: [ :name :objectId | 
			(availableResults at: objectId ifAbsent: [ nil ]) = name
				ifFalse: [ aStream
						nextPutAll: name;
						nextPutAll: ' := '.
					self
						writeProvenanceArgument: objectId
						using: availableResults
						on: aStream.
					aStream
						nextPut: $.;
						cr.
					(declaredNames includes: name) ifFalse: [ declaredNames add: name ] ] ]
]
