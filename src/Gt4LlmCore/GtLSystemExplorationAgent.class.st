"
Agent for exploration-oriented tasks.
"
Class {
	#name : #GtLSystemExplorationAgent,
	#superclass : #GtLAgent,
	#category : #'Gt4LlmCore-Agents'
}

{ #category : #accessing }
GtLSystemExplorationAgent >> description [
	^ 'An agent specialized in exploring the current system and context.'
]

{ #category : #accessing }
GtLSystemExplorationAgent >> lepiterExplanationPageName [
	^ 'Instructions for the System Exploration Agent'
]

{ #category : #accessing }
GtLSystemExplorationAgent >> name [
	^ 'explore'
]
