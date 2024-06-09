Class {
	#name : #Gt4LlmHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #Gt4Llm
}

{ #category : #accessing }
Gt4LlmHomeSection >> lepiterCard [
	<gtSectionCard>
	^ GtHomeCard lepiterBaseWithTableOfContents
		title: 'Glamorous Toolkit for LLMs';
		description: 'Read the docs';
		priority: 10;
		pageName: 'Glamorous Toolkit for LLMs';
		databaseName: 'gt4llm-lepiter';
		details: [ :db | 
			'This knowledge base documents the interactions with various LLMs.' ]
]

{ #category : #accessing }
Gt4LlmHomeSection >> sectionTitle [
	^ 'Glamorous Toolkit for Large Language Models'
]
