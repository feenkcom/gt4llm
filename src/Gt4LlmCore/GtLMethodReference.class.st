"
I name a method by class name, selector and side, as the LLM tools receive and return it.

I name the place where the method's source is defined. I resolve only to a method that the class (or its metaclass, when classSide is true) defines itself. A method that the class inherits, or gets from a trait, resolves to an error domain object: {{gtClass:GtLMissingInheritedMethodDomainObject}}, {{gtClass:GtLMissingTraitMethodDomainObject}}, {{gtClass:GtLMissingRequiredTraitMethodDomainObject}} or {{gtClass:GtLMissingTraitConflictMethodDomainObject}}. These name the method or methods that define the source, so they can be used in a new request.

{{gtMethod:GtLMethodReference>>#lookupCompiledMethodIfPresent:ifMissing:}} looks the method up through the superclasses instead.
"
Class {
	#name : #GtLMethodReference,
	#superclass : #Object,
	#instVars : [
		'methodName',
		'classSide',
		'methodClassName'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #private }
GtLMethodReference class >> definitionOf: aCompiledMethod [
	"A conflict is defined where it is. #originMethod answers a copy for an alias inside a sequence such as (TA @ {#b -> #a}) + TB; ask the trait composition instead, and repeat, because the used trait can hold a copy too"

	| anOrigin |
	(aCompiledMethod isFromTrait and: [ aCompiledMethod isConflict not ])
		ifFalse: [ ^ aCompiledMethod ].
	anOrigin := aCompiledMethod originMethod.
	anOrigin isFromTrait ifFalse: [ ^ anOrigin ].
	anOrigin := aCompiledMethod methodClass traitComposition
			compiledMethodAt: aCompiledMethod selector.
	^ anOrigin == aCompiledMethod
		ifTrue: [ aCompiledMethod ]
		ifFalse: [ self definitionOf: anOrigin ]
]

{ #category : #'instance creation' }
GtLMethodReference class >> fromCompiledMethod: aMethod [ 
	^ self new 
			initializeFromCompiledMethod: aMethod 
]

{ #category : #'instance creation' }
GtLMethodReference class >> fromDefinitionOf: aCompiledMethod [
	"Return a reference to the method whose source defines aCompiledMethod: the trait method for a copy provided by a trait, aCompiledMethod itself otherwise"

	^ self fromCompiledMethod: (self definitionOf: aCompiledMethod)
]

{ #category : #comparing }
GtLMethodReference >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	(self class = anObject class) ifFalse: [ ^ false ].
	^ self methodClassName = anObject methodClassName
		and: [ self methodName = anObject methodName
		and: [ self classSide = anObject classSide ] ]
]

{ #category : #enumerating }
GtLMethodReference >> behaviorIfPresent: aPresentBlock ifMissing: anErrorBlock [
	| targetClass |
	self methodClassName
		ifNil: [ ^ anErrorBlock
				value: (GtLMissingArgumentDomainObject new
						arguments: nil;
						missingArgument: 'methodClassName') ].
	self methodName
		ifNil: [ ^ anErrorBlock
				value: (GtLMissingArgumentDomainObject new
						arguments: nil;
						missingArgument: 'methodName') ].
	targetClass := Smalltalk at: self methodClassName asSymbol ifAbsent: [ nil ].
	(targetClass notNil and: [ targetClass isBehavior ])
		ifFalse: [ ^ anErrorBlock
				value: (GtLMissingDomainObject new objectName: self methodClassName) ].
	self isClassSide ifTrue: [ targetClass := targetClass class ].
	^ aPresentBlock value: targetClass
]

{ #category : #accessing }
GtLMethodReference >> classSide [
	^ classSide 
]

{ #category : #accessing }
GtLMethodReference >> classSide: anObject [
	classSide := anObject
]

{ #category : #descriptions }
GtLMethodReference >> classSideDescription [
	<magritteDescription>
	
	^ MABooleanDescription new
		label: 'Class side';
		accessor: #classSide;
		beRequired
]

{ #category : #accessing }
GtLMethodReference >> compiledMethod [
	^ self
		compiledMethodIfPresent: [ :aMethod | aMethod ]
		ifMissing: [ :aMissingDomainObject | NotFound signal: aMissingDomainObject errorMessage ]
]

{ #category : #enumerating }
GtLMethodReference >> compiledMethodIfPresent: aPresentBlock ifMissing: anErrorBlock [
	"A reference names the place where the method's source is defined. Only a method the class (or metaclass) defines itself is present; an inherited method or a copy provided by a trait is missing, and the error names the method that defines it."

	^ self
		behaviorIfPresent: [ :aBehavior | 
			| aSelector |
			aSelector := self methodName asSymbol.
			(aBehavior includesLocalSelector: aSelector)
				ifTrue: [ aPresentBlock value: aBehavior >> aSelector ]
				ifFalse: [ anErrorBlock value: (self missingMethodDomainObjectIn: aBehavior) ] ]
		ifMissing: anErrorBlock
]

{ #category : #testing }
GtLMethodReference >> existsInImage [
	^ self 
			compiledMethodIfPresent: [ :each | true ] 
			ifMissing: [ :each | false ]
]

{ #category : #'gt - views' }
GtLMethodReference >> gtActionBrowseEntryFor: anAction [
	<gtAction>
	
	self existsInImage ifFalse: [ ^ anAction noAction ].
	
	^ anAction button
			label: 'Browse';
			priority: 3;
			tooltip: 'Browse current version of this method';
			action: [ :aButton | 
				aButton phlow spawnTool: (GtMethodCoderTool compiledMethod:
						self compiledMethod)  ] 
]

{ #category : #views }
GtLMethodReference >> gtClassCoderViewFor: aView [
	<gtView>
	<gtCodeChangeView>
	
	self existsInImage ifFalse: [ ^ aView empty ].
	
	^ aView explicit
		title: 'Coder';
		priority: 20;
		stencil: [ (GtCoderElement forMethod: self compiledMethod) disablePlayPage ]
]

{ #category : #'gt - views' }
GtLMethodReference >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 2;
		items: [ {
			'Method class' -> self methodClassName.
			'Method name' -> self methodName.
			'Class side' -> self classSide.
			'Signature' -> self methodSignature.
			'Exists in image' -> self existsInImage } ];
		column: 'Property' text: [ :assoc | assoc key ] width: 250;
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #comparing }
GtLMethodReference >> hash [
	^ (self methodClassName hash bitXor: self methodName hash)
		bitXor: self classSide hash
]

{ #category : #initialization }
GtLMethodReference >> initializeFromCompiledMethod: aMethod [ 
	methodClassName := aMethod methodClass instanceSide name asString.
	methodName := aMethod selector asString. 
	classSide := aMethod methodClass isClassSide
]

{ #category : #testing }
GtLMethodReference >> isClassSide [ 
	^ classSide 
		ifNil: [ false ]
		ifNotNil: [ :aValue | #(true 'true' 't') includes: aValue ]
]

{ #category : #'llm views' }
GtLMethodReference >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #enumerating }
GtLMethodReference >> lookupCompiledMethodIfPresent: aPresentBlock ifMissing: anErrorBlock [
	^ self
		behaviorIfPresent: [ :aBehavior | 
			(aBehavior lookupSelector: self methodName asSymbol)
				ifNil: [ anErrorBlock
						value: (GtLMissingDomainObject new objectName: self methodSignature) ]
				ifNotNil: [ :aMethod | aPresentBlock value: aMethod ] ]
		ifMissing: anErrorBlock
]

{ #category : #accessing }
GtLMethodReference >> methodClass [
	| targetClass |
	targetClass := self methodClassName asClass.
	self isClassSide 
		ifTrue: [ targetClass := targetClass class ].
	^ targetClass
]

{ #category : #accessing }
GtLMethodReference >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLMethodReference >> methodClassName: anObject [
	methodClassName := anObject
]

{ #category : #descriptions }
GtLMethodReference >> methodClassNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Class name';
		accessor: #methodClassName;
		beRequired
]

{ #category : #accessing }
GtLMethodReference >> methodName [
	^ methodName
]

{ #category : #accessing }
GtLMethodReference >> methodName: anObject [
	methodName := anObject
]

{ #category : #descriptions }
GtLMethodReference >> methodNameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		label: 'Method name';
		accessor: #methodName;
		beRequired
]

{ #category : #enumerating }
GtLMethodReference >> methodObjectIfMissing: anErrorBlock [
	^ self
		compiledMethodIfPresent: [ :aMethod | 
			aMethod isSourceSearchable
				ifTrue: [ GtLMethodWithSource fromCompiledMethod: aMethod ]
				ifFalse: [ GtLNotSourceSearchableMethod  fromCompiledMethod: aMethod ] ]
		ifMissing: anErrorBlock
]

{ #category : #printing }
GtLMethodReference >> methodSignature [
	^ '{1}{2}>>#{3}'
			format: {
				self methodClassName.
				self isClassSide ifTrue: [ ' class' ] ifFalse: [ '' ].
				self methodName}
]

{ #category : #private }
GtLMethodReference >> missingMethodDomainObjectFor: aMethod reportedAs: aMissingLocalMethodClass [
	aMethod isConflict
		ifTrue: [ ^ GtLMissingTraitConflictMethodDomainObject
				methodReference: self
				conflict: aMethod ].
	aMethod isExplicitlyRequired
		ifTrue: [ ^ self missingRequiredMethodDomainObjectFor: aMethod ].
	^ aMissingLocalMethodClass methodReference: self definedBy: aMethod
]

{ #category : #private }
GtLMethodReference >> missingMethodDomainObjectIn: aBehavior [
	"Only called when aBehavior does not define the method itself, so a method in its method dictionary is a copy provided by a trait"

	| aSelector |
	aSelector := self methodName asSymbol.
	(aBehavior includesSelector: aSelector)
		ifTrue: [ ^ self
				missingMethodDomainObjectFor: aBehavior >> aSelector
				reportedAs: GtLMissingTraitMethodDomainObject ].
	^ (aBehavior lookupSelector: aSelector)
		ifNil: [ GtLMissingDomainObject new objectName: self methodSignature ]
		ifNotNil: [ :anInheritedMethod | 
			self
				missingMethodDomainObjectFor: anInheritedMethod
				reportedAs: GtLMissingInheritedMethodDomainObject ]
]

{ #category : #private }
GtLMethodReference >> missingRequiredMethodDomainObjectFor: aRequirement [
	"A superclass may implement what the trait requires; the lookup can first meet further copies of the requirement"

	^ (aRequirement methodClass superclass
		ifNotNil: [ :aSuperclass | aSuperclass lookupSelector: aRequirement selector ])
		ifNil: [ GtLMissingRequiredTraitMethodDomainObject
				methodReference: self
				definedBy: aRequirement ]
		ifNotNil: [ :anInheritedMethod | 
			self
				missingMethodDomainObjectFor: anInheritedMethod
				reportedAs: GtLMissingInheritedMethodDomainObject ]
]

{ #category : #printing }
GtLMethodReference >> printOn: aStream [ 
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self methodSignature]
]
