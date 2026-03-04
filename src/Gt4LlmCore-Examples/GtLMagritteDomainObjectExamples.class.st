Class {
	#name : #GtLMagritteDomainObjectExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMagritteDomainObjectExamples >> methodReferenceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodReferenceObject jsonObject |
	methodReferenceObject := GtLMethodReference 
		fromCompiledMethod: (GtLMethodReference class>>#fromCompiledMethod:) .
	
	self
		assert: methodReferenceObject methodName
		equals: #fromCompiledMethod:.
	self 
		assert: methodReferenceObject methodClassName 
		equals: #GtLMethodReference.
	self
		assert: methodReferenceObject classSide
		equals: true.
	self
		assert: methodReferenceObject isClassSide
		equals: true.
	self
		assert: methodReferenceObject methodSignature
		equals: 'GtLMethodReference class>>#fromCompiledMethod:'.
	self
		assert: methodReferenceObject methodClass
		equals: GtLMethodReference class.
	self
		assert: methodReferenceObject compiledMethod
		equals: (GtLMethodReference class>>#fromCompiledMethod:).
	
	jsonObject := GtMagritteJSONDataExporter exportObject: methodReferenceObject .
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new) 
			at: 'methodName' 
				put: #fromCompiledMethod:;
			at: 'classSide' put:  true; 
			at: 'methodClassName' put: #GtLMethodReference; 
			yourself).

	^ methodReferenceObject
]

{ #category : #examples }
GtLMagritteDomainObjectExamples >> methodReferenceObjectFromCompiledMethodInstanceSide [
	<gtExample>
	| methodReferenceObject jsonObject |
	methodReferenceObject := GtLMethodReference fromCompiledMethod: (GtLMagritteDomainObjectExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide).
					
	self
		assert: methodReferenceObject methodName
		equals: #methodReferenceObjectFromCompiledMethodInstanceSide.
	self
		assert: methodReferenceObject methodClassName
		equals: #GtLMagritteDomainObjectExamples.
	self
		assert: methodReferenceObject classSide
		equals: false.
	self
		assert: methodReferenceObject isClassSide
		equals: false.
	self
		assert: methodReferenceObject methodSignature
		equals: 'GtLMagritteDomainObjectExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide'.
	self
		assert: methodReferenceObject methodClass
		equals: GtLMagritteDomainObjectExamples.
	self
		assert: methodReferenceObject compiledMethod
		equals: (GtLMagritteDomainObjectExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide).
	
	jsonObject := GtMagritteJSONDataExporter exportObject: methodReferenceObject .
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new) 
			at: 'methodName' 
				put: #methodReferenceObjectFromCompiledMethodInstanceSide;
			at: 'classSide' put:  false; 
			at: 'methodClassName' put: #GtLMagritteDomainObjectExamples; 
			yourself).

	^ methodReferenceObject
]

{ #category : #examples }
GtLMagritteDomainObjectExamples >> methodWithNotSearchableSourceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodObject jsonObject |
	methodObject := GtLNotSourceSearchableMethod 
		fromCompiledMethod: (GtLMethodReference class>>#fromCompiledMethod:) .
	
	self
		assert: methodObject methodName
		equals: #fromCompiledMethod:.
	self 
		assert: methodObject methodClassName 
		equals: #GtLMethodReference.
	self
		assert: methodObject isClassSide
		equals: true.
	self
		assert: methodObject methodClass
		equals: GtLMethodReference class.
	self
		assert: methodObject compiledMethod
		equals: (GtLMethodReference class>>#fromCompiledMethod:).
	self
		assert: methodObject sourceCode
		equals: '<not searchable method>'.
	
	jsonObject := GtMagritteJSONDataExporter exportObject: methodObject .
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new)
			at: 'methodReference' put: ((NeoJSONObject new)
				at: 'methodName' put: 'fromCompiledMethod:';
				at: 'methodClassName' put: 'GtLMethodReference';
				at: 'classSide' put: true;
				yourself);
			at: 'sourceCode' put: '<not searchable method>';
	yourself).

	^ methodObject
]

{ #category : #examples }
GtLMagritteDomainObjectExamples >> methodWithSourceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodObject jsonObject |
	methodObject := GtLMethodWithSource 
		fromCompiledMethod: (GtLMethodReference class>>#fromCompiledMethod:) .
	
	self
		assert: methodObject methodName
		equals: #fromCompiledMethod:.
	self 
		assert: methodObject methodClassName 
		equals: #GtLMethodReference.
	self
		assert: methodObject isClassSide
		equals: true.
	self
		assert: methodObject methodClass
		equals: GtLMethodReference class.
	self
		assert: methodObject compiledMethod
		equals: (GtLMethodReference class>>#fromCompiledMethod:).
	self
		assert: methodObject sourceCode
		equals: (GtLMethodReference class>>#fromCompiledMethod:) sourceCode.
	
	jsonObject := GtMagritteJSONDataExporter exportObject: methodObject .
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new)
			at: 'methodReference' put: ((NeoJSONObject new)
				at: 'methodName' put: 'fromCompiledMethod:';
				at: 'methodClassName' put: 'GtLMethodReference';
				at: 'classSide' put: true;
				yourself);
			at: 'sourceCode' put: 'fromCompiledMethod: aMethod 
	^ self new 
			initializeFromCompiledMethod: aMethod ';
	yourself).

	^ methodObject
]
