"
I convert the recorded changes under an Iceberg class node into a class change history.
"
Class {
	#name : #GtLIceClassChangeHistoryBuilder,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #'instance creation' }
GtLIceClassChangeHistoryBuilder class >> historyFor: anIceNode [
	^ self new historyFor: anIceNode
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> classChangeFrom: aPreviousClass to: anUpdatedClass [
	| result label |
	anUpdatedClass
		ifNil: [ result := GtLClassRemovalResult new
					removedClass: aPreviousClass;
					status: 'removed';
					yourself.
			label := 'Removed class' ]
		ifNotNil: [ result := GtLClassModificationResult new
					originalClass: aPreviousClass;
					updatedClass: anUpdatedClass;
					yourself.
			label := aPreviousClass
					ifNil: [ 'Added class' ]
					ifNotNil: [ 'Changed class definition' ] ].
	^ GtLSummarizerCodeChange new
		label: label;
		changeResult: result;
		yourself
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> classDescriptionFor: anIceDefinition [
	| definition |
	anIceDefinition ifNil: [ ^ nil ].
	definition := anIceDefinition asMCDefinition.
	^ GtLClassDefinitionDescription new
		currentClassName: definition name;
		superclassName: definition superclassName;
		packageName: definition packageName;
		packageTagName: definition tagName;
		comment: definition comment;
		instanceSlotNames: (self variableNamesFrom: definition instVarNames);
		classSlotNames: (self variableNamesFrom: definition classInstVarNames);
		classVariableNames: (self variableNamesFrom: definition classVarNames);
		traitCompositionString: definition traitCompositionString;
		isTrait: false;
		yourself
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> classNodesFor: anIceNode [
	| definition className siblingKey |
	anIceNode hasParent ifFalse: [ ^ {anIceNode} ].
	definition := anIceNode definition.
	className := definition basicName asString.
	siblingKey := definition isMeta
			ifTrue: [ className ]
			ifFalse: [ className , ' class' ].
	anIceNode parent
		childAt: siblingKey
		ifPresent: [ :aSibling | 
			(self isClassChangeNode: aSibling)
				ifTrue: [ ^ definition isMeta
						ifTrue: [ {aSibling.
								anIceNode} ]
						ifFalse: [ {anIceNode.
								aSibling} ] ] ].
	^ {anIceNode}
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> definitionAfter: anOperation [
	anOperation isRemoval ifTrue: [ ^ nil ].
	^ anOperation leftDefinition
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> definitionBefore: anOperation [
	anOperation isAddition ifTrue: [ ^ nil ].
	anOperation isModification ifTrue: [ ^ anOperation rightDefinition ].
	^ anOperation definition
]

{ #category : #building }
GtLIceClassChangeHistoryBuilder >> historyFor: anIceNode [
	| classNodes classOperation previousClass updatedClass history |
	(self isClassChangeNode: anIceNode) ifFalse: [ ^ nil ].
	classNodes := self classNodesFor: anIceNode.
	classOperation := (classNodes
			detect: [ :aNode | aNode value hasChanges ]
			ifNone: [ anIceNode ]) value.
	previousClass := self
			classDescriptionFor: (self definitionBefore: classOperation).
	updatedClass := self
			classDescriptionFor: (self definitionAfter: classOperation).
	history := GtLClassChangeHistory new
			targetClassName: anIceNode definition basicName asString;
			yourself.
	classOperation hasChanges
		ifTrue: [ history
				addBehaviourChange: (self classChangeFrom: previousClass to: updatedClass) ].
	classNodes
		do: [ :aNode | 
			aNode
				do: [ :anOperation | 
					(self isMethodChange: anOperation for: history targetClassName)
						ifTrue: [ history
								addMethodHistory: (self
										methodHistoryFor: anOperation
										previousClass: previousClass
										updatedClass: updatedClass) ] ] ].
	^ history
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> isClassChangeNode: anIceNode [
	^ (anIceNode isKindOf: IceNode)
		and: [ (self isSupportedOperation: anIceNode value)
				and: [ anIceNode definition isClassDefinition ] ]
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> isMethodChange: anOperation for: aClassName [
	^ (self isSupportedOperation: anOperation)
		and: [ anOperation hasChanges
				and: [ anOperation definition isMethodDefinition
						and: [ anOperation definition className asString = aClassName ] ] ]
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> isSupportedOperation: anOperation [
	^ (anOperation isKindOf: IceOperation)
		and: [ anOperation isAddition
				or: [ anOperation isRemoval
						or: [ anOperation isModification or: [ anOperation isNoModification ] ] ] ]
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> methodHistoryFor: anOperation previousClass: aPreviousClass updatedClass: anUpdatedClass [
	| definition reference previousMethod updatedMethod result label |
	definition := anOperation definition.
	reference := GtLMethodReference new
			methodClassName: definition className asString;
			methodName: definition selector asString;
			classSide: definition classIsMeta;
			yourself.
	previousMethod := self
			methodWithSourceFor: (self definitionBefore: anOperation)
			reference: reference.
	updatedMethod := self
			methodWithSourceFor: (self definitionAfter: anOperation)
			reference: reference.
	updatedMethod
		ifNil: [ result := GtLMethodRemovalResult new
					removedMethod: previousMethod;
					targetClass: aPreviousClass;
					status: 'removed';
					yourself.
			label := 'Removed method' ]
		ifNotNil: [ result := GtLMethodCompilationResult new
					oldMethod: previousMethod;
					newMethod: updatedMethod;
					targetClass: anUpdatedClass;
					status: 'compiled';
					yourself.
			label := previousMethod
					ifNil: [ 'Added method' ]
					ifNotNil: [ 'Modified method' ] ].
	^ GtLMethodChangeHistory new
		methodReference: reference;
		addChange: (GtLSummarizerCodeChange new
				label: label;
				changeResult: result;
				yourself);
		yourself
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> methodWithSourceFor: anIceDefinition reference: aReference [
	^ anIceDefinition
		ifNotNil: [ GtLMethodWithSource new
				methodReference: aReference;
				sourceCode: anIceDefinition sourceCode;
				yourself ]
]

{ #category : #private }
GtLIceClassChangeHistoryBuilder >> variableNamesFrom: someNames [
	^ someNames
		collect: [ :aName | 
			(aName beginsWith: '#')
				ifTrue: [ (OCParser parseExpression: aName) receiver value asString ]
				ifFalse: [ aName ] ]
]
