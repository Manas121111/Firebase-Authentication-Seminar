package com.example.myapplication

import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.database.*

class MainActivity : AppCompatActivity() {

    private lateinit var database: DatabaseReference

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val etId = findViewById<EditText>(R.id.etId)
        val etName = findViewById<EditText>(R.id.etName)
        val etSection = findViewById<EditText>(R.id.etSection)
        val etPhone = findViewById<EditText>(R.id.etPhone)
        val txtResult = findViewById<TextView>(R.id.txtResult)

        val btnAdd = findViewById<Button>(R.id.btnAdd)
        val btnUpdate = findViewById<Button>(R.id.btnUpdate)
        val btnDelete = findViewById<Button>(R.id.btnDelete)
        val btnShow = findViewById<Button>(R.id.btnShow)

        database = FirebaseDatabase.getInstance().reference.child("Students")
        Toast.makeText(
            this,
            FirebaseDatabase.getInstance().reference.root.toString(),
            Toast.LENGTH_LONG
        ).show()

        fun getId(): String {
            val id = etId.text.toString().trim()
            if (id.isEmpty()) {
                toast("Please enter Student ID")
                throw Exception("ID EMPTY")
            }
            return id
        }

        btnAdd.setOnClickListener {
            try {
                val id = getId()
                val data = mapOf(
                    "name" to etName.text.toString(),
                    "section" to etSection.text.toString(),
                    "phone" to etPhone.text.toString()
                )
                database.child(id).setValue(data)
                toast("Student Added")
            } catch (_: Exception) {}
        }

        btnUpdate.setOnClickListener {
            try {
                val id = getId()
                database.child(id).updateChildren(
                    mapOf(
                        "name" to etName.text.toString(),
                        "section" to etSection.text.toString(),
                        "phone" to etPhone.text.toString()
                    )
                )
                toast("Student Updated")
            } catch (_: Exception) {}
        }

        btnDelete.setOnClickListener {
            try {
                val id = getId()
                database.child(id).removeValue()
                toast("Student Deleted")
            } catch (_: Exception) {}
        }

        btnShow.setOnClickListener {
            database.addListenerForSingleValueEvent(object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    val builder = StringBuilder()
                    for (s in snapshot.children) {
                        builder.append("ID: ${s.key}\n")
                        builder.append("Name: ${s.child("name").value}\n")
                        builder.append("Section: ${s.child("section").value}\n")
                        builder.append("Phone: ${s.child("phone").value}\n\n")
                    }
                    txtResult.text = builder.toString()
                }

                override fun onCancelled(error: DatabaseError) {
                    toast("Database Error")
                }
            })
        }
    }

    private fun toast(msg: String) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()
    }
}