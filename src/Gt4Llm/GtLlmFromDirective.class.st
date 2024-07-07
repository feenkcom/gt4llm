Class {
	#name : #GtLlmFromDirective,
	#superclass : #GtLlmModelfileDirective,
	#category : #'Gt4Llm-Modelfiles'
}

{ #category : #accessing }
GtLlmFromDirective >> directiveKind [
	^ 'FROM'
]

{ #category : #accessing }
GtLlmFromDirective >> treatText [
	^ self text
]
