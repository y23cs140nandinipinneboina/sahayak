/*
  # Fix Teachers Table RLS Policy

  1. Security Updates
    - Drop existing INSERT policy for teachers table
    - Create new INSERT policy with correct auth.uid() function
    - Ensure authenticated users can create their own teacher profile

  This fixes the "new row violates row-level security policy" error during signup.
*/

-- Drop the existing INSERT policy
DROP POLICY IF EXISTS "Users can create own teacher profile" ON teachers;

-- Create a new INSERT policy with the correct auth.uid() function
CREATE POLICY "Users can create own teacher profile"
  ON teachers
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);