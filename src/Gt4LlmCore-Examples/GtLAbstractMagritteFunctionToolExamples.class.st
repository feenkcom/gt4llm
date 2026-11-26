"
Abstract superclass for examples testing GtLAbstractMagritteFunctionTool and its subclasses.
"
Class {
	#name : #GtLAbstractMagritteFunctionToolExamples,
	#superclass : #GtLAbstractFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #helpers }
GtLAbstractMagritteFunctionToolExamples >> executeTool: aTool withArguments: aDictionary [
	"Execute the tool with the given arguments and return the tool call.
	Asserts common properties that should be the same for all tool calls."
	
	| call result |
	call := GtLFunctionToolCall new.
	call rawArguments: aDictionary.
	result := aTool performToolCall: call.
	
	self assert: call tool == aTool.
	self assert: (result isKindOf: GtLWrappedObjectModel).
	self assert: call arguments size equals: aDictionary size.
	
	^ call
]

{ #category : #helpers }
GtLAbstractMagritteFunctionToolExamples >> executeTool: aTool withArguments: aDictionary inContext: aContext [
	"Execute the tool with the given arguments in the given context and return the tool call.
	Asserts common properties that should be the same for all tool calls."
	
	| call result |
	call := GtLFunctionToolCall new.
	call rawArguments: aDictionary.
	result := aTool performToolCall: call inContext: aContext.
	
	self assert: call tool == aTool.
	self assert: (result isKindOf: GtLWrappedObjectModel).
	self assert: call arguments size equals: aDictionary size.
	
	^ call
]

{ #category : #support }
GtLAbstractMagritteFunctionToolExamples >> jsonOf: aToolCall [
	"Return the JSON response of aToolCall, as the agent gets it"

	^ NeoJSONReader
		fromString: (aToolCall result serializeForMCPResponseOutput first at: 'text')
]

{ #category : #support }
GtLAbstractMagritteFunctionToolExamples >> modelOf: aToolCall [
	"Return what aToolCall answered. The refactoring tools answer a report: return the preview or result it reports on"

	| anObject |
	anObject := aToolCall result targetObject.
	^ (anObject isKindOf: GtLRefactoringReport)
		ifTrue: [ anObject refactoring ]
		ifFalse: [ anObject ]
]

{ #category : #fixtures }
GtLAbstractMagritteFunctionToolExamples >> removeDummies: anEnvironment [
	"Remove the temporary classes, the classes added to their packages and the packages, and the names the classes leave in Undeclared.
	Remove the methods first: the method index then forgets them, and a later rename does not find them"

	| allClasses dummyClasses names |
	allClasses := anEnvironment realPackages
			flatCollect: [ :aPackage | aPackage definedClasses ].
	dummyClasses := anEnvironment dummyPackages
			flatCollect: [ :aPackage | aPackage dummyClasses collect: [ :each | each realClass ] ].
	names := (allClasses collect: [ :each | each name ]) asSet.
	anEnvironment dummyPackages
		do: [ :aPackage | aPackage dummyClasses do: [ :each | names add: each className ] ].
	EpMonitor
		disableDuring: [ allClasses
				do: [ :aClass | 
					{aClass instanceSide.
						aClass classSide}
						do: [ :aBehavior | aBehavior localSelectors do: [ :each | aBehavior removeSelector: each ] ] ].
			((allClasses reject: [ :each | dummyClasses includes: each ])
				sorted: [ :a :b | a isTrait not or: [ b isTrait ] ])
				do: [ :aClass | aClass removeFromSystem ] ].
	anEnvironment removeFromSystem.
	names do: [ :each | Undeclared removeKey: each asSymbol ifAbsent: [  ] ]
]

{ #category : #fixtures }
GtLAbstractMagritteFunctionToolExamples >> withDummies: aGeneratorBlock do: aBlock [
	"Evaluate aBlock with the temporary classes made by aGeneratorBlock, in an isolated change manager, and remove them afterwards, with the classes added to their packages"

	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ | anEnvironment |
			anEnvironment := aGeneratorBlock value.
			[ aBlock value: anEnvironment ] ensure: [ self removeDummies: anEnvironment ] ]
]

{ #category : #fixtures }
GtLAbstractMagritteFunctionToolExamples >> withDummyHierarchyDo: aBlock [
	"Evaluate aBlock with the root and the leaf class of a temporary hierarchy of two classes"

	^ self
		withDummies: [ GtPharoDummiesGenerator withPackages: 1 classHierarchy: 2 ]
		do: [ :anEnvironment | 
			| aLeafClass |
			aLeafClass := anEnvironment anyDummyLeafClass realClass.
			aBlock value: aLeafClass superclass value: aLeafClass ]
]
