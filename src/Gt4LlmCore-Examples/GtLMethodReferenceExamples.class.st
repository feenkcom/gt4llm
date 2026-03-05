Class {
	#name : #GtLMethodReferenceExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodClassSide [
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
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodInstanceSide [
	<gtExample>
	| methodReferenceObject jsonObject |
	methodReferenceObject := GtLMethodReference fromCompiledMethod: (GtLMethodReferenceExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide).
					
	self
		assert: methodReferenceObject methodName
		equals: #methodReferenceObjectFromCompiledMethodInstanceSide.
	self
		assert: methodReferenceObject methodClassName
		equals: #GtLMethodReferenceExamples.
	self
		assert: methodReferenceObject classSide
		equals: false.
	self
		assert: methodReferenceObject isClassSide
		equals: false.
	self
		assert: methodReferenceObject methodSignature
		equals: 'GtLMethodReferenceExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide'.
	self
		assert: methodReferenceObject methodClass
		equals: GtLMethodReferenceExamples.
	self
		assert: methodReferenceObject compiledMethod
		equals: (GtLMethodReferenceExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide).
	
	jsonObject := GtMagritteJSONDataExporter exportObject: methodReferenceObject .
	self 
		assert: jsonObject
		equals: ((NeoJSONObject new) 
			at: 'methodName' 
				put: #methodReferenceObjectFromCompiledMethodInstanceSide;
			at: 'classSide' put:  false; 
			at: 'methodClassName' put: #GtLMethodReferenceExamples; 
			yourself).

	^ methodReferenceObject
]
