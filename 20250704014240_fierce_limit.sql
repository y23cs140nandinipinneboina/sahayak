/*
  # Fix Teachers Table RLS Policy for Signup

  1. Security Changes
    - Drop the existing restrictive INSERT policy for teachers
    - Create a new INSERT policy that allows authenticated users to create their own teacher profile
    - The policy checks that the user ID matches the auth.uid() to ensure users can only create their own profile

  2. Policy Details
    - Policy name: "Users can create own teacher profile"
    - Allows INSERT operations for authenticated users
    - Restricts insertion to only allow users to create profiles with their own user ID
*/

-- Drop the existing INSERT policy that's too restrictive
DROP POLICY IF EXISTS "Teachers can insert own profile" ON teachers;

-- Create a new INSERT policy that allows users to create their own teacher profile
CREATE POLICY "Users can create own teacher profile"
  ON teachers
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);