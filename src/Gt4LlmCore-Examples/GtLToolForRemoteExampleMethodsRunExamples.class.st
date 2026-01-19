Class {
	#name : #GtLToolForRemoteExampleMethodsRunExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #'accessing - method dictionary' }
GtLToolForRemoteExampleMethodsRunExamples class >> addAndClassifySelector: selector withMethod: compiledMethod inProtocol: aProtocol [
	"When a new methods is added, I add it to the localMethodDict and also propagate the changes to my users"
	<reflection: 'Class structural modification - Selector/Method modification'>
	self localMethodDict at: selector put: compiledMethod.

	super addAndClassifySelector: selector withMethod: compiledMethod inProtocol: aProtocol.

	TraitChange addSelector: selector on: self
]

{ #category : #querying }
GtLToolForRemoteExampleMethodsRunExamples class >> allTraits [
	<reflection: 'Class structural inspection - Traits'>
	^ self traitComposition allTraits
]

{ #category : #initialization }
GtLToolForRemoteExampleMethodsRunExamples class >> doRebuildMethodDictionary [

	| selectors removedSelectors modified |
	"During the creation of the class or after a change in the traitComposition, the whole method dictionary is calculated.
	If I return true, my users should be updated""1. I recreate the local methodDict"
	modified := false.
	self methodDict valuesDo: [ :m | m traitSource ifNil: [ self localMethodDict at: m selector put: m ] ].

	"2. I filter the selectors from the trait composition, rejecting the ones that are locally defined.
	And then I install the methods in myself. The trait composition only install the method if it is needed."
	selectors := self traitComposition selectors reject: [ :e | self localMethodDict includesKey: e ].
	selectors do: [ :e | modified := modified | (self traitComposition installSelector: e into: self replacing: false) ].

	"3. I handle the methods that I have and they are no more in the traitComposition."
	removedSelectors := self methodDict keys reject: [ :aSelector | (selectors includes: aSelector) or: [ self localMethodDict includesKey: aSelector ] ].
	modified := modified | removedSelectors isNotEmpty.
	removedSelectors do: [ :aSelector |
		self methodDict removeKey: aSelector.
		self removeFromProtocols: aSelector ].

	^ modified
]

{ #category : #testing }
GtLToolForRemoteExampleMethodsRunExamples class >> findOriginClassOf: aMethod [

	"I return the myself or the trait that has the original implementation of a method.
	If the method is an alias, the returned class includes the original aliased method"
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	
	(aMethod hasProperty: #traitSource)
		ifTrue: [ ^ aMethod traitSource innerClass ].

	(self includesLocalSelector: aMethod selector)
		ifTrue: [ ^ self ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ ^ self ]) innerClass
]

{ #category : #testing }
GtLToolForRemoteExampleMethodsRunExamples class >> findOriginMethodOf: aMethod [

	"I return the original method for a aMethod.
	If this is a local method, the original method is itself.
	If it cames from a trait composition I look for the method in the trait composition.
	First I try with the trait stored in the traitSource.
	If it is an aliased or conflicting method, the method is look up in the whole trait composition"
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	
	(self includesLocalSelector: aMethod selector)
		ifTrue: [ ^ aMethod ].

	(aMethod hasProperty: #traitSource)
		ifTrue: [ |newSelector|
			newSelector := self traitComposition originSelectorOf: aMethod selector.
			^ aMethod traitSource compiledMethodAt: newSelector ifAbsent: [aMethod] ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ self ])
		compiledMethodAt: aMethod selector ifAbsent: [ ^ aMethod ]
]

{ #category : #testing }
GtLToolForRemoteExampleMethodsRunExamples class >> hasTraitComposition [

	^ self traitComposition isEmpty not
]

{ #category : #testing }
GtLToolForRemoteExampleMethodsRunExamples class >> includesLocalSelector: aSymbol [
	<reflection: 'Class structural inspection - Shared pool inspection'>
	^ self isLocalSelector: aSymbol
]

{ #category : #testing }
GtLToolForRemoteExampleMethodsRunExamples class >> includesTrait: aTrait [

	<reflection: 'Class structural inspection - Traits'>
	^ self traitComposition includesTrait: aTrait
]

{ #category : #testing }
GtLToolForRemoteExampleMethodsRunExamples class >> isAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my or in another composition somewhere deeper in
	the tree of traits compositions."

	^ self traitComposition isAliasSelector: aSymbol
]

{ #category : #testing }
GtLToolForRemoteExampleMethodsRunExamples class >> isLocalAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my trait composition."

	^ self traitComposition isLocalAliasSelector: aSymbol
]

{ #category : #testing }
GtLToolForRemoteExampleMethodsRunExamples class >> isLocalSelector: aSelector [
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	^ self localMethodDict includesKey: aSelector
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRunExamples class >> localMethodDict [
	"The local methodDict is in the metaclass. In this way I do not have to recompile the methods during the bootstrap when we don't have a compiler."
	^ self class baseLocalMethods
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRunExamples class >> localMethodDict: aMethodDictionary [
	^ self class baseLocalMethods: aMethodDictionary
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRunExamples class >> localMethods [
	"returns the methods of classes excluding the ones of the traits that the class uses"
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	^ self localMethodDict values
]

{ #category : #'accessing - method dictionary' }
GtLToolForRemoteExampleMethodsRunExamples class >> localSelectors [
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	^ self localMethodDict keys
]

{ #category : #initialization }
GtLToolForRemoteExampleMethodsRunExamples class >> rebuildMethodDictionary [

	"Useful to be rewritten in Traits"
	^ self doRebuildMethodDictionary
]

{ #category : #categories }
GtLToolForRemoteExampleMethodsRunExamples class >> recategorizeSelector: selector from: oldProtocol to: newProtocol [
	"When a method is recategorized I have to classify the method, but also recategorize the aliases pointing to it"

	| originalProtocol |
	"If it is nil is because it is a removal. It will removed when the method is removed."
	newProtocol ifNil: [ ^ self ].

	originalProtocol := (self protocolOfSelector: selector) ifNil: [ ^ self ].
	originalProtocol name = oldProtocol name ifTrue: [ self classify: selector under: newProtocol name ].

	(self traitComposition reverseAlias: selector) do: [ :selectorAlias |
		self recategorizeSelector: selectorAlias from: oldProtocol to: newProtocol.
		self notifyOfRecategorizedSelector: selectorAlias from: oldProtocol to: newProtocol ]
]

{ #category : #recompilation }
GtLToolForRemoteExampleMethodsRunExamples class >> recompile: selector from: oldClass [

	super recompile: selector from: oldClass.
	TraitChange addSelector: selector on: self
]

{ #category : #'trait-composition' }
GtLToolForRemoteExampleMethodsRunExamples class >> removeFromComposition: aTrait [

	self setTraitComposition: (self traitComposition copyWithoutTrait: aTrait asTraitComposition)
]

{ #category : #removing }
GtLToolForRemoteExampleMethodsRunExamples class >> removeFromSystem: logged [

	"When a traited class is removed the traits it is using should be updated"
	| mySubclasses |
	self traitComposition removeUser: self.
	self class traitComposition removeUser: self class.

	TraitedClass removeUser: self class.

	mySubclasses := self subclasses.

	super removeFromSystem: logged.

	"As I am a traited class my subclasses does not have the basic traited class
	methods, so I add them."
	mySubclasses do: [ :each | each class initializeBasicMethods ]
]

{ #category : #removing }
GtLToolForRemoteExampleMethodsRunExamples class >> removeSelector: aSelector [

	"When a selector is removed it should be notified to my users.
	Check the class TraitChange for more details"
	<reflection: 'Class structural modification - Selector/Method modification'>
	super removeSelector: aSelector.
	self localMethodDict removeKey: aSelector ifAbsent: [  ].

	TraitChange removeSelector: aSelector on: self
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRunExamples class >> traitComposition [
	"My trait composition is in my class. So I do not need to recompile the methods when installing them during bootstrap"
	^ self class baseComposition
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRunExamples class >> traitComposition: aComposition [

	aComposition asTraitComposition allTraits do: [ :aMaybeTrait |
		aMaybeTrait isTrait ifFalse: [
			self error: 'All the members of the trait composition should be traits' ]].

	self class baseComposition: aComposition
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRunExamples class >> traitCompositionString [
	^ self traitComposition asString
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRunExamples class >> traitUsers [
	"I am a traited class, I have no users, this is for compatibility with traits"
		<reflection: 'Class structural inspection - Traits'>
	^ #()
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRunExamples class >> traits [
	<reflection: 'Class structural inspection - Traits'>
	^ self traitComposition traits
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> addClassToEventFactory [
	"Confirm that class definitions are added as expected to the event factory"

	<gtExample>
	| tool eventFactory classDefinition omEntry epClassAddition rgClassAddition |
	self forPharo12AndNewer: [  ] forPharo11: [ ^ self ].

	tool := GtLToolForRemoteExampleMethodsRun new.
	eventFactory := GtEpiceaEventFactory new.
	classDefinition := {'type' -> 'class'.
			'code'
				-> 'Object << #SomeClass
	slots: #(someSlotA someSlotB);
	sharedVariables: #(ClassVar1 ClassVar2);
	package: ''SomePackage'''} asDictionary.
	tool
		addClass: classDefinition
		to: eventFactory
		onProblemDo: [ :aDomainObject | ^ self error: 'Could not add class' ].

	self assert: eventFactory entries size equals: 1.
	omEntry := eventFactory entries first.
	epClassAddition := omEntry content.
	self assert: epClassAddition class equals: EpClassAddition.
	self assert: epClassAddition behaviorAffectedName equals: #SomeClass.
	rgClassAddition := epClassAddition behaviorAffected.
	self
		assert: (rgClassAddition instanceVariables collect: #name as: Array)
		equals: #(someSlotA someSlotB).
	self
		assert: (rgClassAddition classVariables collect: #name as: Array)
		equals: #(ClassVar1 ClassVar2).

	^ tool
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> addMethodToEventFactory [
	"Confirm that method definitions are added as expected to the event factory"
	<gtExample>
	| tool eventFactory methodDefinition omEntry epMethodAddition rgMethodAddition |

	tool := GtLToolForRemoteExampleMethodsRun new.
	eventFactory := GtEpiceaEventFactory new.
	methodDefinition := {
		'type' -> 'method'.
		'class' -> self class name asString.
		'code' ->
'fortyTwo
	^ 42'.
		} asDictionary.
	tool addMethod: methodDefinition to: eventFactory.

	self assert: eventFactory entries size equals: 1.
	omEntry := eventFactory entries first.
	epMethodAddition := omEntry content.
	self assert: epMethodAddition class equals: EpMethodAddition.
	self assert: epMethodAddition behaviorAffectedName equals: self class name asString.
	rgMethodAddition := epMethodAddition methodAffected.
	self assert: rgMethodAddition sourceCode
		equals: (methodDefinition at: 'code').
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> addRemoveClassToEventFactory [
	"Confirm that class definitions are added as expected to the event factory"

	<gtExample>
	| tool eventFactory classDefinition omEntry epClassRemoval rgClassRemoval |
	self forPharo12AndNewer: [  ] forPharo11: [ ^ self ].

	tool := GtLToolForRemoteExampleMethodsRun new.
	eventFactory := GtEpiceaEventFactory new.
	classDefinition := {'type' -> 'class'.
			'code'
				-> 'Object << #SomeClass
	slots: #(someSlotA someSlotB);
	sharedVariables: #(ClassVar1 ClassVar2);
	package: ''SomePackage'''} asDictionary.
	tool
		addRemoveClass: classDefinition
		to: eventFactory
		onProblemDo: [ :aDomainObject | self error: 'Cannot remove class' ].

	self assert: eventFactory entries size equals: 1.
	omEntry := eventFactory entries first.
	epClassRemoval := omEntry content.
	self assert: epClassRemoval class equals: EpClassRemoval.
	self assert: epClassRemoval behaviorAffectedName equals: #SomeClass.
	rgClassRemoval := epClassRemoval behaviorAffected.
	self
		assert: (rgClassRemoval instanceVariables collect: #name as: Array)
		equals: #(someSlotA someSlotB).
	self
		assert: (rgClassRemoval classVariables collect: #name as: Array)
		equals: #(ClassVar1 ClassVar2).

	^ tool
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> addRemoveMethodToEventFactory [
	"Confirm that method definitions are added as expected to the event factory"
	<gtExample>
	| tool eventFactory methodDefinition omEntry epMethodRemoval rgMethodRemoval |

	tool := GtLToolForRemoteExampleMethodsRun new.
	eventFactory := GtEpiceaEventFactory new.
	methodDefinition := {
		'type' -> 'method'.
		'class' -> self class name asString.
		'code' ->
'fortyTwo
	^ 42'.
		} asDictionary.
	tool addRemoveMethod: methodDefinition to: eventFactory.

	self assert: eventFactory entries size equals: 1.
	omEntry := eventFactory entries first.
	epMethodRemoval := omEntry content.
	self assert: epMethodRemoval class equals: EpMethodRemoval.
	self assert: epMethodRemoval behaviorAffectedName equals: self class name asString.
	rgMethodRemoval := epMethodRemoval methodAffected.
	self assert: rgMethodRemoval sourceCode
		equals: (methodDefinition at: 'code').
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> assert: actualNumber closeTo: expectedNumber [
	^ self
		assert: (actualNumber closeTo: expectedNumber)
		description: [self comparingStringBetween: actualNumber and: expectedNumber]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> assert: aBooleanOrBlock description: aStringOrBlock [
	aBooleanOrBlock value ifFalse: [
		| message |
		message := aStringOrBlock value.
		self classForTestResult failure signal: message]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> assert: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean [
	| exception |
	aBooleanOrBlock value
		ifFalse:
			[|aString|
			aString := aStringOrBlock value.
			exception := resumableBoolean
						ifTrue: [self classForTestResult resumableFailure]
						ifFalse: [self classForTestResult failure].
			exception signal: aString]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> assert: actual equals: expected [
	^ self
		assert: actual = expected
		description: [self comparingStringBetween: actual and: expected]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> assert: actual identicalTo: expected [
	^ self
		assert: expected == actual
		description: [self comparingIdentityStringBetween: actual and: expected]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> assertCollection: actual equals: expected [
	"Specialized test method that generates a proper error message for collection"
	^ self
		assert: expected = actual
		description: [ self comparingCollectionBetween: actual and: expected ]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> assertCollection: actual hasSameElements: expected [
	"Assert that a collection contains the same elements as the given collection. Order is not checked, only the presence/absence of elements. Occurences of elements mater."

	| missingElements additionalElements |
	"For performance reasons we check first that they are not equals because difference computation takes long on collections that are not really small."
	actual = expected ifTrue: [ ^ self ].

	"The fast way to know if they have the same elements is to make them a bag. In case they don't have the same elements, then we compute the differences to print a nice little log to the user so that he knows the added and removed elements :)"
	actual asBag = expected asBag ifTrue: [ ^ self ].

	additionalElements := actual difference: expected.
	missingElements := expected difference: (actual intersection: expected).
	self assert: (additionalElements isEmpty and: [ missingElements isEmpty ]) description: (String streamContents: [ :stream |
			 stream
				 nextPutAll: 'Given Collections do not match!';
				 lf;
				 tab;
				 nextPutAll: 'additions : ';
				 print: additionalElements asArray;
				 lf;
				 tab;
				 nextPutAll: 'missing: ';
				 print: missingElements asArray;
				 lf ])
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> assertEmpty: aCollection [
	^ self assert: aCollection isEmpty description: aCollection asString , ' should have been empty'
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> classForTestResult [
	"Returns the class of the test result"
	^ TestResult
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRunExamples >> comparingCollectionBetween: left and: right [
	| additionalLeft additionalRight sortBlock|

	"use a very slow sort block"
	sortBlock := [ :a :b | a asString <= b asString ].
	additionalLeft := (left difference: right) sorted: sortBlock.
	additionalRight := (right difference: left) sorted: sortBlock.

	^ String streamContents: [:stream |
		stream
			nextPutAll: 'Given Collections do not match. Got '; lf;
			tab; nextPutAll: 'left := '; print: left; nextPut: $.; lf;
			nextPutAll: ' instead of ';
			tab; nextPutAll: ' right :='; print: left; nextPut: $.; lf.
		left size = right size
			ifFalse: [
				stream
					nextPutAll: 'Collection size does not match: left=';
					print: left size;
					nextPutAll: ' vs. right=';
					print: right size; lf ].
		additionalLeft isEmpty
			ifFalse: [
				stream
					nextPutAll: 'Got ';
					print: additionalLeft size;
					nextPutAll: ' additional element(s) in the left collection: ';
					tab; print: additionalLeft  ].
		additionalRight isEmpty
			ifFalse: [
				stream
					nextPutAll: 'Got ';
					print: additionalRight size;
					nextPutAll: ' additional element(s) in the right collection: ';
					tab; print: additionalRight  ]]
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRunExamples >> comparingIdentityStringBetween: actual and: expected [

	^ String streamContents: [ :stream |
		  stream
			  print: actual;
			  nextPutAll: ' is not identical to ';
			  print: expected;
			  nextPut: $. ]
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRunExamples >> comparingStringBetween: actual and: expected [

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: 'Got ';
			  print: actual;
			  nextPutAll: ' instead of ';
			  print: expected;
			  nextPut: $. ]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> deny: aBooleanOrBlock [

	self assert: aBooleanOrBlock value not
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> deny: aBooleanOrBlock description: aString [
	self assert: aBooleanOrBlock value not description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> deny: aBooleanOrBlock description: aString resumable: resumableBoolean [
	self
		assert: aBooleanOrBlock value not
		description: aString
		resumable: resumableBoolean
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> deny: actual equals: expected [
	^ self
		deny: expected = actual
		description: [self unexpectedEqualityStringBetween: actual and: expected]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> deny: actual identicalTo: expected [
	^ self
		deny: expected == actual
		description: [self unexpectedIdentityEqualityStringBetween: actual and: expected]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> denyCollection: actual equals: expected [
	"Specialized test method that generates a proper error message for collection"
	^ self
		deny: expected = actual
		description: [ self unexpectedEqualityStringBetween: actual and: expected ]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> denyCollection: actual hasSameElements: expected [
	"Deny that a collection contains the same elements as the given collection. Order is not checked, only the presence/absence of elements."

	self
		deny: ((actual difference: expected) isEmpty and: [ (expected difference: actual) isEmpty ])
		description: 'Given collections match!'
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> denyEmpty: aCollection [
	"Not using #isNotEmpty like this objects as parameter can only implement #isEmpty and not both messages."

	^ self assert: aCollection isEmpty not description: aCollection asString , ' should not have been empty'
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunFailsWithoutCheckNames [
	"Expect the tool to signal the missing checkNames error"

	<gtExample>
	| tool call result errorDictionary message |
	tool := GtLToolForRemoteExampleMethodsRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'changes' -> '[]'} asDictionary} asDictionary.
	result := tool performToolCall: call.

	self assert: result isErrorDomainObject.
	self assert: result missingArgument equals: 'checkNames'.

	^ call
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunNewClassDefinition [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where
	- the changes define a new class
	- an example that checks for the existence of the class passes
	- neither the class or example exist in the main image"
	<gtExample>
	<noTest>
	| tool call resultString result results exampleNamePrefix exampleClassDefinition exampleSource exampleClassName exampleSelector resultDictionary |

	self forPharo12AndNewer: [] forPharo11: [ ^ self ].

	tool := GtLToolForRemoteExampleMethodsRun new.
	call := GtLFunctionToolCall new.
	exampleClassName := #GtLlmToolForRemoteExampleMethodsRunExamplesTestClass.
	exampleSelector := #checkExampleTestClassPresence.
	self assert: (self class environment classOrTraitNamed: exampleClassName) isNil
		description: [ 'The example class ', exampleClassName asString, ' already exists' ].
	self assert: (self class lookupSelector: exampleSelector) isNil
		description: [ 'The example method ', exampleSelector asString, ' already exists' ].
	exampleNamePrefix := self class name asString, '>>'.
	exampleClassDefinition := String streamContents: [ :stream |
		stream
			<< 'Object << ';
			print: exampleClassName;
			cr; tab;
			<< 'package: ';
			print: self class package name asString ].
	exampleSource := String streamContents: [ :stream |
		stream
			<< exampleSelector;
			cr;
			cr; tab;
			<< 'self assert: (self class environment classOrTraitNamed: ';
			print: exampleClassName;
			<< ') isNotNil.' ].
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> (STONJSON toString: {
				exampleNamePrefix, exampleSelector.
				}).
			'changes' -> (STONJSON toString: {
				{
					'type' -> 'method'.
					'class' -> self class name asString.
					'code' -> exampleSource.
				} asDictionary.
				{
					'type' -> 'class'.
					'code' -> exampleClassDefinition.
				} asDictionary })
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
	self assert: results size equals: 1.
	resultDictionary := results first at: 'result' ifAbsent:
		[ self error: '''result'' not found in: ', (STONJSON toStringPretty: resultDictionary) ].
	self assert: resultDictionary equals: 'pass'.
	^ tool
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunRejectsNonArrayCheckNames [
	"checkNames must deserialize to an Array"

	<gtExample>
	| tool call result |
	tool := GtLToolForRemoteExampleMethodsRun new.
	call := GtLFunctionToolCall new.
	call
		function: {'name' -> tool name.
				'arguments' -> {'checkNames' -> '"not-an-array"'} asDictionary} asDictionary.
	result := tool performToolCall: call.
	self assert: result isErrorDomainObject.
	self assert: result argumentName equals: 'checkNames'.
	self assert: result expectedArgumentValueKind equals: Array.

	^ call
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunRejectsUnknownChangeType [
    "Non-method change dictionaries should fail fast"
    <gtExample>
    | tool call resultString result errorDictionary message |
    tool := GtLToolForRemoteExampleMethodsRun new.
    call := GtLFunctionToolCall new.
    call function: {
        'name' -> tool name.
        'arguments' -> {
            'checkNames' -> (STONJSON toString: {
                self class name asString, '>>exampleSuccess'
            }).
            'changes' -> (STONJSON toString: {
                {
                    'type' -> 'junk'.
                    'junk' -> 'rubbish'.
                } asDictionary
            }).
        } asDictionary
    } asDictionary.
    resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	errorDictionary := result at: 'error' ifAbsent:
		[ self error: '''error'' not found in: ', (STONJSON toStringPretty: result) ].
	message := errorDictionary at: 'message' ifAbsent:
		[ self error: '''message'' not found in: ', (STONJSON toStringPretty: errorDictionary) ].
	self assert: message equals: 'Unknown type: ''junk'''.
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunReportsDetailsForFailures [
    "Ensure failure entries include message and stackTrace"
    <gtExample>
    <noTest>
    | tool call result results message |
    tool := GtLToolForRemoteExampleMethodsRun new.
    call := GtLFunctionToolCall new.
    call function: {
        'name' -> tool name.
        'arguments' -> {
            'checkNames' -> (STONJSON toString: {
                self class name asString, '>>exampleSuccess'.
                self class name asString, '>>exampleFailure'.
            }).
            'changes' -> (STONJSON toString: {
                {
                    'type' -> 'method'.
                    'class' -> self class name asString.
                    'code' -> 'exampleFailure
    <gtExample>
    ^ self assert: false'.
                } asDictionary
            }).
        } asDictionary
    } asDictionary.
    result := STONJSON fromString: (tool performToolCall: call).
    results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
    message := (results detect: 
    	[ :each | (each at: 'method') = 'exampleFailure' ])
        	at: 'message'.
    self assert: message equals: 'Assertion failed'.
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunSuccess [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where a collection of changes that don't exist in the main image is provided and a collection of examples that depends on the changes is run."
	<gtExample>
	<noTest>
	| tool call resultString result results exampleNamePrefix |

	tool := GtLToolForRemoteExampleMethodsRun new.
	call := GtLFunctionToolCall new.
	exampleNamePrefix := self class name asString, '>>'.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> (STONJSON toString: {
				exampleNamePrefix, 'exampleSuccess'.
				exampleNamePrefix, 'exampleFailure'.
				exampleNamePrefix, 'exampleError'.
				}).
			'changes' -> (STONJSON toString: {
				{
					'type' -> 'method'.
					'class' -> self class name asString.
					'code' ->
'exampleFailure
	<gtExample>

	^ self assert: false.'.
				} asDictionary.
				{
					'type' -> 'method'.
					'class' -> self class name asString.
					'code' ->
'exampleError
	<gtExample>

	^ self error: ''an error''.'.
				} asDictionary. }).
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
	self assert: results size equals: 3.
	self assert: (results collect: [ :resultDictionary |
		resultDictionary at: 'result' ifAbsent:
			[ self error: '''result'' not found in: ', (STONJSON toStringPretty: resultDictionary) ] ] as: Set) equals:
		#('pass' 'failure' 'error') asSet.
	^ tool
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunSuccessEmptyChanges [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where a collection of changes that don't exist in the main image is provided and a collection of examples that depends on the changes is run."
	<gtExample>
	<noTest>
	| tool call resultString result results exampleNamePrefix testResult |

	tool := GtLToolForRemoteExampleMethodsRun new.
	call := GtLFunctionToolCall new.
	exampleNamePrefix := self class name asString, '>>'.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> (STONJSON toString: {
				exampleNamePrefix, 'exampleSuccess'.
				}).
			'changes' -> '[]'.
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
	self assert: results size equals: 1.
	testResult := results first at: 'result' ifAbsent:
		[ self error: '''result'' not found in: ', (STONJSON toStringPretty: testResult)].
	self assert: testResult equals: 'pass'.
	^ tool
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunSuccessNoChanges [
	"Confirm that the GtLlmToolForRemoteExampleMethodsRun tool behaves as expected in the case where a collection of changes that don't exist in the main image is provided and a collection of examples that depends on the changes is run."
	<gtExample>
	<noTest>
	| tool call resultString result results exampleNamePrefix |

	tool := GtLToolForRemoteExampleMethodsRun new.
	call := GtLFunctionToolCall new.
	exampleNamePrefix := self class name asString, '>>'.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'checkNames' -> (STONJSON toString: {
				exampleNamePrefix, 'exampleSuccess'.
				}).
		} asDictionary
	} asDictionary.
	resultString := tool performToolCall: call.
	result := STONJSON fromString: resultString.
	self assert: call tool == tool.
	self assert: result class name equals: #Dictionary.
	self assert: result size equals: 1.
	results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
	self assert: results size equals: 1.
	self assert: (results first at: 'result') equals: 'pass'.
	^ tool
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleRunWithHashSelectors [
    "Ensure #example selectors are normalized"
    <gtExample>
    <noTest>
    | tool call result results |
    tool := GtLToolForRemoteExampleMethodsRun new.
    call := GtLFunctionToolCall new.
    call function: {
        'name' -> tool name.
        'arguments' -> {
            'checkNames' -> (STONJSON toString: {
                self class name asString, '>>#exampleSuccess'
            }).
        } asDictionary
    } asDictionary.
    result := STONJSON fromString: (tool performToolCall: call).
    results := result at: 'results' ifAbsent:
		[ self error: '''results'' not found in: ', (STONJSON toStringPretty: result) ].
    self
        assert: (results first at: 'result')
        equals: 'pass'.
]

{ #category : #examples }
GtLToolForRemoteExampleMethodsRunExamples >> exampleSuccess [
	"Simple example that succeeds"
	<gtExample>

	self assert: true.
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> executeShould: aBlock inScopeOf: anExceptionalEvent [
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: true]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: aString [
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: (ex description includesSubstring: aString) ]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: aString [
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: (ex description includesSubstring: aString) not ]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> executeShould: aBlock inScopeOf: anException withExceptionDo: anotherBlock [

	^[aBlock value.
 	false]
		on: anException
		do: [:exception |
			anotherBlock value: exception.
			exception return: true]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> fail [

	^self assert: false
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> fail: aDescriptionString [

	^self assert: false description: aDescriptionString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock [
	self assert: aBlock value
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock description: aString [
	self assert: aBlock value description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock notTakeMoreThan: aDuration [
    "Evaluate aBlock and if it takes more than given duration
    to run we report a test failure. "

	^ aBlock 
		valueWithinMilliseconds: aDuration asMilliSeconds 
		onTimeout: [
			self
				assert: false
				description: ['Block evaluation took more than the expected <1p>' expandMacrosWith: aDuration ]
	]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock notTakeMoreThanMilliseconds: milli [
    "Evaluate aBlock and if it takes more than given milli of milliseconds
    to run we report a test failure. "

	^ aBlock valueWithinMilliseconds: milli onTimeout: [
		self
			assert: false
			description: ['Block evaluation took more than the expected <1p>' expandMacrosWith: milli]
	]
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock raise: anExceptionalEvent [
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock raise: anExceptionalEvent description: aString [
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock raise: anExceptionalEvent whoseDescriptionDoesNotInclude: substring description: aString [
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: substring)
		description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock raise: anExceptionalEvent whoseDescriptionIncludes: substring description: aString [
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: substring)
		description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> should: aBlock raise: anException withExceptionDo: anotherBlock [

	^self assert: (self executeShould: aBlock inScopeOf: anException withExceptionDo: anotherBlock)
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> shouldFix: aBlock [
	"Run the block expecting an Exception. Throw an assertion failure if the block does NOT throw an exception."
	^self should: aBlock raise: Exception
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> shouldnt: aBlock [
	self deny: aBlock value
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> shouldnt: aBlock description: aString [
	self deny: aBlock value description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> shouldnt: aBlock raise: anExceptionalEvent [

	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> shouldnt: aBlock raise: anExceptionalEvent description: aString [

	^self
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
		description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> shouldnt: aBlock raise: anExceptionalEvent whoseDescriptionDoesNotInclude: substring description: aString [

	^self
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: substring) not
		description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> shouldnt: aBlock raise: anExceptionalEvent whoseDescriptionIncludes: substring description: aString [

	^self
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: substring) not
		description: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> signalFailure: aString [
	self classForTestResult failure signal: aString
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> skip [
	"Don't run this test, and don't mark it as failure"
	TestSkipped signal
]

{ #category : #extensions }
GtLToolForRemoteExampleMethodsRunExamples >> skip: aComment [
	"Don't run this test, and don't mark it as failure"
	TestSkipped signal: aComment
]

{ #category : #asserting }
GtLToolForRemoteExampleMethodsRunExamples >> skipUnless: aBooleanOrBlock [
	" If the assumption in aBooleanOrBlock is not true, abandon the running test
	and mark it as passed. "
	aBooleanOrBlock value ifFalse:
			[ TestSkipped signal: 'Assumption in #skipUnless: failed' ]
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRunExamples >> unexpectedEqualityStringBetween: actual and: expected [

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: 'Unexpected equality of ';
			  print: actual;
			  nextPutAll: ' and ';
			  print: expected;
			  nextPut: $. ]
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRunExamples >> unexpectedIdentityEqualityStringBetween: actual and: expected [

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: 'Unexpected identity equality of ';
			  print: actual;
			  nextPutAll: ' and ';
			  print: expected;
			  nextPut: $. ]
]
