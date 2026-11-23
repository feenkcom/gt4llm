"
Examples for {{gtClass:GtLVariableChangeHistory}}: variable histories created on demand from a {{gtClass:GtLClassDefinitionChangeHistory}}.
"
Class {
	#name : #GtLVariableChangeHistoryExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #private }
GtLVariableChangeHistoryExamples >> classChangeWithResult: aClassChangeResult [
	^ GtLSummarizerCodeChange new
		label: 'Changed class signature';
		toolCall: (self toolCallNamed: 'changeClassOrTraitSignature' arguments: Dictionary new);
		changeResult: aClassChangeResult;
		yourself
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> classDefinitionHistory [
	"A class is created with three variables, then gets an instance slot and loses its class slot, then only its comment changes"

	<gtExample>
	| created modified commented history |
	created := self
			descriptionWithInstanceSlots: #(#first)
			classSlots: #(#cache)
			classVariables: #(#Default).
	modified := self
			descriptionWithInstanceSlots: #(#first #second)
			classSlots: #()
			classVariables: #(#Default).
	commented := (self
			descriptionWithInstanceSlots: #(#first #second)
			classSlots: #()
			classVariables: #(#Default))
			comment: 'A commented class';
			yourself.

	history := GtLClassDefinitionChangeHistory new
			targetClassName: 'GtLExampleClass';
			yourself.
	history
		addChange: (self
				classChangeWithResult: (GtLClassModificationResult new
						originalClass: nil;
						updatedClass: created;
						yourself)).
	history
		addChange: (self
				classChangeWithResult: (GtLClassModificationResult new
						originalClass: created;
						updatedClass: modified;
						yourself)).
	history
		addChange: (self
				classChangeWithResult: (GtLClassCommentChangeResult new
						originalClass: modified;
						updatedClass: commented;
						status: 'changed';
						yourself)).

	self assert: history changes size equals: 3.
	self assert: history isInitialChangeAddition.
	^ history
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> classSlotAddedThenRemoved [
	"Each variable change is a summarizer code change that points back to the class change it was extracted from"

	<gtExample>
	| classHistory histories history addition removal |
	classHistory := self classDefinitionHistory.
	histories := classHistory variableChangeHistories.
	history := histories
			historyForVariableNamed: #cache
			type: GtLClassSlotType uniqueInstance.

	self assert: history changes size equals: 2.
	self assert: history hasNoEffect.

	addition := history initialChange.
	self assert: addition label equals: 'Added class slot'.
	self assert: addition isVariableAdditionResult.
	self assert: addition changeResult variableName equals: 'cache'.
	self assert: addition changeResult classChange == classHistory changes first.
	self assert: addition toolCall == classHistory changes first toolCall.

	removal := history latestChange.
	self assert: removal label equals: 'Removed class slot'.
	self assert: removal isVariableRemovalResult.
	self assert: removal changeResult classChange == (classHistory changes at: 2).
	self assert: removal toolCall == (classHistory changes at: 2) toolCall.

	self
		assert: (histories
				historyForVariableNamed: #cache
				type: GtLInstanceSlotType uniqueInstance) isNil.
	^ history
]

{ #category : #private }
GtLVariableChangeHistoryExamples >> descriptionWithInstanceSlots: someInstanceSlotNames classSlots: someClassSlotNames classVariables: someClassVariableNames [
	^ GtLClassDefinitionDescription new
		currentClassName: 'GtLExampleClass';
		superclassName: 'Object';
		packageName: 'GtLExamplePackage';
		comment: '';
		instanceSlotNames: someInstanceSlotNames;
		classSlotNames: someClassSlotNames;
		classVariableNames: someClassVariableNames;
		traitCompositionString: '{}';
		yourself
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> instanceSlotsAddedThenReplaced [
	"A class is created with firstName, lastName and address; a later change replaces firstName and lastName with fullName. The history of firstName has two changes: its addition and its removal"

	<gtExample>
	| withNames withFullName creation replacement classHistory histories firstNameHistory |
	withNames := self
			descriptionWithInstanceSlots: #(#firstName #lastName #address)
			classSlots: #()
			classVariables: #().
	withFullName := self
			descriptionWithInstanceSlots: #(#fullName #address)
			classSlots: #()
			classVariables: #().
	creation := self
			classChangeWithResult: (GtLClassModificationResult new
					originalClass: nil;
					updatedClass: withNames;
					yourself).
	replacement := self
			classChangeWithResult: (GtLClassModificationResult new
					originalClass: withNames;
					updatedClass: withFullName;
					yourself).
	classHistory := GtLClassDefinitionChangeHistory new
			targetClassName: 'GtLExampleClass';
			addChange: creation;
			addChange: replacement;
			yourself.
	histories := classHistory variableChangeHistories.

	self
		assert: (histories collect: [ :each | each variableName ]) asArray
		equals: #('firstName' 'lastName' 'address' 'fullName').

	firstNameHistory := histories
			historyForVariableNamed: #firstName
			type: GtLInstanceSlotType uniqueInstance.
	self
		assert: (firstNameHistory changes collect: [ :each | each label ]) asArray
		equals: #('Added instance slot' 'Removed instance slot').
	self
		assert: firstNameHistory initialChange changeResult classChange == creation.
	self
		assert: firstNameHistory latestChange changeResult classChange == replacement.
	self assert: firstNameHistory hasNoEffect.

	self
		assert: (histories
				historyForVariableNamed: #lastName
				type: GtLInstanceSlotType uniqueInstance) changes size
		equals: 2.
	self
		assert: (histories
				historyForVariableNamed: #address
				type: GtLInstanceSlotType uniqueInstance) changes size
		equals: 1.
	self
		assert: (histories
				historyForVariableNamed: #fullName
				type: GtLInstanceSlotType uniqueInstance) initialChange changeResult
				classChange == replacement.
	^ firstNameHistory
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> slotMovedToClassSideAndBack [
	"An existing instance slot cache moves to the class side and back. Instance slot cache and class slot cache get separate histories; the instance slot history starts with a removal"

	<gtExample>
	| onInstanceSide onClassSide classHistory histories instanceSlotHistory classSlotHistory |
	onInstanceSide := self
			descriptionWithInstanceSlots: #(#cache)
			classSlots: #()
			classVariables: #().
	onClassSide := self
			descriptionWithInstanceSlots: #()
			classSlots: #(#cache)
			classVariables: #().
	classHistory := GtLClassDefinitionChangeHistory new
			targetClassName: 'GtLExampleClass';
			addChange: (self
					classChangeWithResult: (GtLClassModificationResult new
							originalClass: onInstanceSide;
							updatedClass: onClassSide;
							yourself));
			addChange: (self
					classChangeWithResult: (GtLClassModificationResult new
							originalClass: onClassSide;
							updatedClass: onInstanceSide;
							yourself));
			yourself.
	histories := classHistory variableChangeHistories.
	self assert: histories size equals: 2.

	instanceSlotHistory := histories
			historyForVariableNamed: #cache
			type: GtLInstanceSlotType uniqueInstance.
	self
		assert: (instanceSlotHistory changes collect: [ :each | each label ]) asArray
		equals: #('Removed instance slot' 'Added instance slot').
	self assert: instanceSlotHistory isInitialChangeAddition not.
	self assert: instanceSlotHistory isLatestChangeRemoval not.
	self assert: instanceSlotHistory hasNoEffect not.

	classSlotHistory := histories
			historyForVariableNamed: #cache
			type: GtLClassSlotType uniqueInstance.
	self
		assert: (classSlotHistory changes collect: [ :each | each label ]) asArray
		equals: #('Added class slot' 'Removed class slot').
	self assert: classSlotHistory hasNoEffect.
	^ histories
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> variableChangeDetailsElements [
	"Variable histories and their changes provide the icon, description and diff used by the views"

	<gtExample>
	| history detailsElements |
	history := self classSlotAddedThenRemoved.
	self
		assert: history gtViewChangeIcon
		equals: (Smalltalk ui icons iconNamed: #windowMinimizeInactive).
	self
		assert: history initialChange gtViewChangeIcon
		equals: GtLCodeChangeResult additionIcon.
	self
		assert: history latestChange gtViewChangeIcon
		equals: GtLCodeChangeResult removalIcon.
	self
		assert: (history gtViewChangeDescriptionElement query // BrLabel) anyOne text asString
		equals: 'Class slot cache'.
	self
		assert: (history changes items
				allSatisfy: [ :each | each asDiffElement isKindOf: BlElement ]).

	detailsElements := {history} , history changes items
			collect: [ :each | GtLCodeChangesDetailsElement new codeChange: each ].
	^ detailsElements
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> variableChangeHistories [
	"Each variable gets one history, in the order in which it first changed; the comment change adds nothing"

	<gtExample>
	| classHistory histories |
	classHistory := self classDefinitionHistory.
	histories := classHistory variableChangeHistories.

	self assert: histories class equals: GtLVariableChangeHistoriesGroup.
	self
		assert: (histories collect: [ :each | each gtDisplayString ]) asArray
		equals: #('Instance slot first' 'Class slot cache' 'Class variable Default' 'Instance slot second').
	self
		assert: (histories collect: [ :each | each changes size ]) asArray
		equals: #(1 2 1 1).
	self
		assert: (histories allSatisfy: [ :each | each classDefinitionHistory == classHistory ]).
	self
		assert: (histories allSatisfy: [ :each | each targetClassName = 'GtLExampleClass' ]).
	self assert: (histories allSatisfy: [ :each | each isInitialChangeAddition ]).
	^ histories
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> variableChangeHistoriesAfterClassRemoval [
	"Removing a class ends the history of each of its variables with a removal"

	<gtExample>
	| classHistory histories |
	classHistory := self classDefinitionHistory.
	classHistory
		addChange: (self
				classChangeWithResult: (GtLClassRemovalResult new
						removedClass: classHistory latestChange changeResult updatedClass;
						status: 'removed';
						yourself)).
	histories := classHistory variableChangeHistories.

	self assert: histories size equals: 4.
	self assert: (histories allSatisfy: [ :each | each hasNoEffect ]).
	self
		assert: ((histories reject: [ :each | each variableName = 'cache' ])
				allSatisfy: [ :each | each latestChange changeResult classChange == classHistory latestChange ]).
	^ histories
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> variableChangeHistoriesForPushUpInstanceVariable [
	"Pushing up an instance variable removes it from the subclass and adds it to the superclass, both through the same tool call"

	<gtExample>
	| summarizer histories addition removal |
	summarizer := GtLCodeChangesToolCallsSummarizerExamples new
			summarizerWithAppliedPushUpInstanceVariableRefactoring.
	histories := summarizer classChangeHistories variableHistories.

	self assert: histories class equals: GtLVariableChangeHistoriesGroup.
	self assert: histories size equals: 2.
	self assert: (histories allSatisfy: [ :each | each variableName = 'instVar3' ]).
	self
		assert: (histories
				allSatisfy: [ :each | each variableType = GtLInstanceSlotType uniqueInstance ]).

	addition := (histories detect: [ :each | each isInitialChangeAddition ])
			initialChange.
	removal := (histories detect: [ :each | each isLatestChangeRemoval ])
			latestChange.
	self
		assert: addition changeResult targetClassName ~= removal changeResult targetClassName.
	self assert: addition toolCall == removal toolCall.
	^ histories
]

{ #category : #examples }
GtLVariableChangeHistoryExamples >> variableTypes [
	"The three variable types are unique, compare by class and read their names from a class definition as strings"

	<gtExample>
	| variableTypes description |
	variableTypes := GtLVariableType all.
	self
		assert: variableTypes
		equals: {GtLInstanceSlotType uniqueInstance.
				GtLClassSlotType uniqueInstance.
				GtLClassVariableType uniqueInstance}.
	self
		assert: GtLInstanceSlotType uniqueInstance == GtLInstanceSlotType uniqueInstance.
	self assert: GtLInstanceSlotType new equals: GtLInstanceSlotType uniqueInstance.
	self
		assert: GtLInstanceSlotType new hash
		equals: GtLInstanceSlotType uniqueInstance hash.
	self
		assert: GtLInstanceSlotType uniqueInstance ~= GtLClassSlotType uniqueInstance.

	description := self
			descriptionWithInstanceSlots: #(#first #second)
			classSlots: #(#cache)
			classVariables: #(#Default).
	self
		assert: (variableTypes collect: [ :each | each namesIn: description ])
		equals: #(#('first' 'second') #('cache') #('Default')).
	self
		assert: ((variableTypes collect: [ :each | each namesIn: description ])
				allSatisfy: [ :names | names allSatisfy: [ :each | each isSymbol not ] ]).
	^ variableTypes
]
